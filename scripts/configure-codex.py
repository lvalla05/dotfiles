"""Merge local execution, context and browser defaults without replacing account config."""
import copy
import json
import os
from pathlib import Path
import re
import stat
import sys
import tempfile
import tomllib

DESIRED = {"approval_policy": "never", "sandbox_mode": "danger-full-access"}
ASIDE = {"command": str(Path.home() / ".local/bin/aside"), "args": ["mcp"]}

def enable_context_management(text, parsed):
    features = parsed.get("features", {})
    if not isinstance(features, dict):
        raise ValueError("Expected a features table")
    context = features.get("context_management")
    if isinstance(context, dict) and context.get("experimental_mode") is True:
        return text
    if context is not None and not isinstance(context, (dict, bool)):
        raise ValueError("Expected a context_management table or boolean")
    if isinstance(context, dict) and "experimental_mode" in context:
        if not isinstance(context["experimental_mode"], bool):
            raise ValueError("Expected a boolean experimental_mode")

    result = []
    section = None
    found = False
    removed_boolean = False
    for line in text.splitlines(keepends=True):
        if line.lstrip().startswith("["):
            section = None
            if re.match(r'^\s*\[\s*features\s*\.\s*context_management\s*\]\s*(?:#.*)?$', line):
                section = "context"
                found = True
                result.extend([line.rstrip("\r\n") + "\n", "experimental_mode = true\n"])
                continue
            if re.match(r'^\s*\[\s*features\s*\]\s*(?:#.*)?$', line):
                section = "features"
        if section == "context" and re.match(r'^\s*experimental_mode\s*=', line):
            continue
        if section == "features" and isinstance(context, bool) and re.match(r'^\s*context_management\s*=', line):
            removed_boolean = True
            continue
        result.append(line)
    if not found:
        if context is not None and not removed_boolean:
            raise ValueError("Use a [features.context_management] table to update experimental_mode")
        result.append("\n[features.context_management]\nexperimental_mode = true\n")
    return "".join(result)

def merge(text):
    parsed = tomllib.loads(text)
    lines = text.splitlines(keepends=True)
    result = []
    in_table = False
    for line in lines:
        if line.lstrip().startswith("["):
            in_table = True
        match = re.match(r'^\s*(approval_policy|sandbox_mode)\s*=', line)
        if match and not in_table:
            if not isinstance(parsed.get(match[1]), str):
                raise ValueError("Expected a string execution-mode setting")
            continue
        result.append(line)
    merged = "".join(f"{key} = {json.dumps(value)}\n" for key, value in DESIRED.items()) + "".join(result)
    merged = enable_context_management(merged, parsed)
    servers = parsed.get("mcp_servers", {})
    if not isinstance(servers, dict):
        raise ValueError("Expected an mcp_servers table")
    if "aside" not in servers:
        merged += "\n[mcp_servers.aside]\n" + "".join(
            f"{key} = {json.dumps(value)}\n" for key, value in ASIDE.items()
        )
    actual = tomllib.loads(merged)
    expected = dict(copy.deepcopy(parsed), **DESIRED)
    features = expected.setdefault("features", {})
    context = features.get("context_management")
    if not isinstance(context, dict):
        context = features["context_management"] = {}
    context["experimental_mode"] = True
    expected.setdefault("mcp_servers", {}).setdefault("aside", ASIDE)
    if actual != expected:
        raise ValueError("Refusing an unexpected configuration change")
    return merged

def main(path):
    path = Path(path).expanduser().resolve()
    path.parent.mkdir(parents=True, exist_ok=True)
    old = path.read_text() if path.exists() else ""
    new = merge(old)
    if new == old:
        return
    mode = stat.S_IMODE(path.stat().st_mode) if path.exists() else 0o600
    fd, temporary = tempfile.mkstemp(prefix=".codex-config-", dir=path.parent)
    try:
        with os.fdopen(fd, "w") as out:
            out.write(new)
        os.chmod(temporary, mode)
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)

if __name__ == "__main__":
    try:
        main(sys.argv[1])
    except (tomllib.TOMLDecodeError, ValueError) as error:
        print(f"WARNING: Codex execution/context settings were not applied; existing config kept: {error}", file=sys.stderr)
