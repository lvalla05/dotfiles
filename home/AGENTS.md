# global agent instructions

- Never use the em dash. Use a plain dash "-" instead.
- Never add your agent name as a co-author or a session link to commit messages.
- A request authorizes its normal in-scope workflow: tests, commits, pushes, PRs in the named repo. Purchases, messages to people, merges, account changes, deletions, force pushes and wider scope need to be named explicitly.
- Secrets never enter files, prompts, chats or git. If a step wants a token pasted, stop and tell me.
- When making technical decisions, do not give much weight to development cost. Prefer quality, simplicity, robustness and long-term maintainability.
- Solve problems by simplifying before adding machinery. No wrappers, control planes or automation until the direct path shows a concrete repeated need.
- When fixing a bug, first reproduce it end to end the way I would hit it.
- Prove it works: show the artifact, the command, the diff. Fix root causes. A skipped step stays in the list as "skip: <reason>".
- Lead with the outcome. Short sentences. Explain what a change does before making it; I am learning the terminal fast and want to understand every piece.
- Install Mac apps through the Nix/Homebrew declaration in ~/.dotfiles, never ad hoc.
- Personal context, session notes and life plans live in the private `brain` repo (Obsidian), never in the public dotfiles.

## Maintaining this file

Keep it under 25 lines; it is loaded into every session of every harness. Every addition names the removal that pays for it. Point at the authoritative file instead of repeating it.
