---
name: aside-browser
description: Use the installed Aside CLI for signed-in web research and browser tasks, including X, Google apps and existing browser sessions. Use native computer control only when the task needs an OS window rather than a webpage.
---

# Aside browser

Read `aside guide` and the relevant command's `--help` before operating it. The installed
CLI owns the current API; do not copy a version-specific browser manual into this skill.

Check `aside account list` and `aside host list`. A signed-in CLI is not proof that its
selected host can see a browser window. If `local` reports no window, inspect the registered
hosts and verify the intended browser with an explicit `--host` before changing a default.
Never copy cookies or credentials to make two clients appear connected.

Use `aside exec` for bounded browsing delegated to Aside. Give it the outcome, source scope,
allowed actions and finish condition. Keep the returned session ID; inspect or resume that
session instead of starting a duplicate after a timeout. Distinguish its model from the
coordinator's model. Read results as evidence and verify consequential claims at the source.

For direct page control, first read `aside guide repl`, run `aside skills list` and read the
matching site skill. List tabs before attaching; use the exact intended tab. Keep one driver
per tab and use task-owned tabs for new work. Prefer site APIs and semantic page actions.
Read back state after a form submission before claiming it succeeded.

A one-shot `aside repl '...'` can close its temporary session and owned tabs when it exits.
Use an interactive REPL for a multi-step browser task, retaining its process/session handle.
Do not assume bindings or `page` survive a new one-shot process. Await asynchronous methods.
The REPL can lack standard globals such as `URL`. Check availability or use supported string
operations; never swallow a parsing error and report it as evidence that an item is absent.

When reading session messages, return visible text and needed tool results only, excluding
reasoning signatures, credentials and unrelated account state. Keep private research in the
private workspace; import only the authorized source material into cloud research notebooks.

For native MCP discovery, `aside mcp` exposes the same browser capability. CLI and MCP are
two interfaces to Aside, not independent browser owners. Confirm the configured host and
account before using either. A remote connection still needs its browser host online.
