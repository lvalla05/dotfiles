# global agent instructions

- Never use the em dash. Use a plain dash "-" instead.
- When writing commit messages, never add your agent name as a co-author and never add a session link.
- Nothing external or irreversible without my word in the moment: no send, submit, purchase, publish, merge, delete, force push, or account change. Drafts and staged work are the deliverable. An approval in one context does not carry to the next.
- Secrets never enter files, prompts, chats, transcripts, or git. If a step wants a token pasted, stop and tell me.
- When making technical decisions, do not give much weight to development cost. Prefer quality, simplicity, robustness, and long-term maintainability.
- For one-off or infrequent operational work, start with the simplest direct end-to-end path. Do not build wrappers, control planes, policy layers, or automation unless the direct path exposes a concrete blocker or a repeated need.
- When fixing a bug, first reproduce it end to end the way I would hit it, so the fix solves the real problem.
- Prove it works: show the artifact, the command, the diff. Fix root causes. A step you skip stays in the list as "skip: <reason>".
- Lead with the outcome. Short sentences. Explain what a change does before making it; I am learning the terminal fast and I want to understand every piece.
- Daily driver is Orca. Use /poteto-mode when the work needs rigor. Launch all harness with permission-bypass.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session on this machine.
Do not repeat what the code already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
