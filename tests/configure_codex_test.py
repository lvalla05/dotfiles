import importlib.util
from pathlib import Path
import tempfile
import subprocess
import sys
import tomllib
import unittest

spec = importlib.util.spec_from_file_location("config", Path(__file__).parents[1] / "scripts/configure-codex.py")
config = importlib.util.module_from_spec(spec)
spec.loader.exec_module(config)

class ConfigureCodexTest(unittest.TestCase):
    def test_preserves_plugins_and_nested_policy(self):
        old = 'model = "chosen-model"\napproval_policy = "on-request" # old\n[profiles.review]\napproval_policy = "untrusted"\n[mcp_servers.example]\nurl = "https://example.invalid/mcp"\n'
        result = config.merge(old)
        data = tomllib.loads(result)
        self.assertEqual(data["model"], "chosen-model")
        self.assertEqual(data["profiles"]["review"]["approval_policy"], "untrusted")
        self.assertEqual(data["mcp_servers"]["example"]["url"], "https://example.invalid/mcp")
        self.assertEqual(data["approval_policy"], "never")
        self.assertTrue(data["features"]["context_management"]["experimental_mode"])
        self.assertEqual(config.merge(result), result)

    def test_preserves_feature_flags_and_context_options(self):
        old = '[features]\nhooks = true\n[features.context_management]\nexperimental_mode = false # previous\nfuture_option = "keep"\n[profiles.review.features.context_management]\nexperimental_mode = false\n'
        result = config.merge(old)
        data = tomllib.loads(result)
        self.assertEqual(data["features"], {"hooks": True, "context_management": {"experimental_mode": True, "future_option": "keep"}})
        self.assertFalse(data["profiles"]["review"]["features"]["context_management"]["experimental_mode"])
        self.assertEqual(config.merge(result), result)

    def test_migrates_boolean_feature_and_preserves_other_flags(self):
        for value in ("false", "true"):
            result = config.merge(f'[features]\ncontext_management = {value}\nhooks = true')
            self.assertEqual(tomllib.loads(result)["features"], {"hooks": True, "context_management": {"experimental_mode": True}})
            self.assertEqual(config.merge(result), result)

    def test_unusual_feature_layout_fails_without_writing(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "config.toml"
            old = '[features]\ncontext_management = { experimental_mode = false }\n'
            path.write_text(old)
            with self.assertRaises(ValueError):
                config.main(path)
            self.assertEqual(path.read_text(), old)

    def test_invalid_config_is_untouched(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "config.toml"
            path.write_text("[broken")
            with self.assertRaises(tomllib.TOMLDecodeError):
                config.main(path)
            self.assertEqual(path.read_text(), "[broken")

    def test_invalid_cli_reports_warning_without_breaking_activation(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "config.toml"
            path.write_text("[broken")
            result = subprocess.run([sys.executable, config.__file__, str(path)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0)
            self.assertIn("WARNING: Codex execution/context settings were not applied", result.stderr)
            self.assertEqual(path.read_text(), "[broken")

    def test_existing_symlink_and_mode_survive(self):
        with tempfile.TemporaryDirectory() as folder:
            target = Path(folder) / "managed.toml"
            target.write_text('model = "chosen-model"\n')
            target.chmod(0o600)
            link = Path(folder) / "config.toml"
            link.symlink_to(target)
            config.main(link)
            self.assertTrue(link.is_symlink())
            self.assertEqual(target.stat().st_mode & 0o777, 0o600)
            self.assertEqual(tomllib.loads(target.read_text())["sandbox_mode"], "danger-full-access")

    def test_new_config_is_private(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "new" / "config.toml"
            config.main(path)
            self.assertEqual(path.stat().st_mode & 0o777, 0o600)
            self.assertEqual(tomllib.loads(path.read_text()), dict(config.DESIRED, features={"context_management": {"experimental_mode": True}}))

if __name__ == "__main__":
    unittest.main()
