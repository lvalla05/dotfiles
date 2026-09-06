# Working with agents

Five levels, from a terminal to a supervised crew. Everything is harness-agnostic: Claude
Code, Codex, Grok Build and pi read the same `home/AGENTS.md`, run in the same terminal and
follow the same review rules.

## 1. The ship

Ghostty is the terminal. `herdr` (declared as a brew, config in `home/.config/herdr`) is the
multiplexer that knows which pane is an agent and whether it is working, blocked or done:
prefix `ctrl+b`, then `c` new tab, `"` and `%` to split, `h j k l` to move, `w` workspaces,
`g` go to, `y` copy mode. Neovim is the editor (`space f` files, `space s` grep, `space g` git,
`space e` file browser). Raycast launches everything else.

## 2. The crew

Every harness gets the same 17-line `home/AGENTS.md`: preferences only. Project knowledge lives
in each repo's own `AGENTS.md` with `CLAUDE.md` containing `@AGENTS.md`. Skills hold the
conditional knowledge (how to test end to end, how to release) so the memory file stays small;
install them with `npx skills add <owner>/<repo> --skill <name> -g`.

Do not install viral skill packs. Generic "coding guideline" files have measured negative effects
on agent pass rates; instruction files earn their lines from real mistakes, not from the internet.

## 3. One crewmate

1. Talk, do not type. Wispr Flow dictates into the harness; type only URLs and paths.
2. Plan in HTML. The `lavish` skill opens a plan as an annotatable page in the browser; mark
   what is wrong, pick options, send it back. Then say "build it".
3. Let it run. `cc` and `co` launch Claude Code and Codex unattended; the machine is
   reproducible and secrets sit behind 1Password and Automic Vault, so the blast radius is a
   rebuild, not a disaster.
4. Review it. Until a project has an architecture and a working first version, the review is
   yours: run the app, read the diff for anything the request did not ask for, keep tests
   green. Once a codebase is established, a review gate for every later change (an
   adversarial review in a fresh context, end-to-end tests with evidence, docs and lint, then
   the PR) is worth adding; evaluate tools such as no-mistakes for that role at that point,
   not before.

## 4. Several crewmates

`treehouse` hands out clean, reusable worktrees: run it in a repo, get a fresh checkout in a
subshell, `exit` returns it to the pool. One herdr tab per crewmate; the agents panel shows who
needs you. For an overnight objective with a verifiable stop condition, `gnhf "<objective>"`
loops one small commit per iteration and waits out subscription limits instead of billing.
`quota-axi` shows every subscription's remaining window before you start something big.
Inside Claude Code, `/goal <condition>` keeps a session working until an evaluator agrees the
condition holds, `/loop` repeats a prompt on an interval, and `/schedule` creates a cloud
Routine that runs with the Mac closed. There is no `/go`. Codex has `/goal` and Codex Cloud.
Life routines stay in Grok Bot; code routines can use Claude Code Routines. One job, one scheduler.

Never run two worktree managers on one repo: if Orca owns a project, treehouse stays out of it.

## 5. A supervisor

Orca's orchestration (a Run, bounded Tasks, `worker-start`, structured completion) plus a
short dispatcher skill of your own cover supervision. Build the dispatcher only when level 4
feels like juggling, and keep it to what the direct path needs: brief a crewmate, watch its
status file, review the result. Grok Bot plays the executive role for life, not code: it runs
in the cloud, holds the daily routines, and reaches the phone with the Mac closed.

## Which harness for what

| Need | Use | Why |
| --- | --- | --- |
| Interactive judgment, terse prose | Claude Code, model Opus 4.8 or Opus 5 | Opus 5 is the Max default; published comparisons still favor Opus 4.8 for conversation |
| Hardest decisions | Fable 5.1 as advisor or for a bounded task at high effort | On Max it is included up to half the weekly window, then metered; it is not a better all-day partner by any published measurement |
| Bulk implementation on GPT | Codex (`co`) with Luna or Terra | Cheapest capable tier; Astra only for the hardest agentic runs |
| Grok models | Grok Build | Included with the Grok subscription |
| GPT and Grok models in one minimal harness | pi (`agent-tools` installs it; config is linked into `~/.pi/agent`) | Sign in with `/login` for ChatGPT or SuperGrok, or API keys. Anthropic and Google forbid their subscription logins in third-party harnesses |
| Life, calendar, tasks, phone | Grok Bot | Cloud executive with routines and connectors |

Install the pinned CLIs and the lavish and quota skills once with `agent-tools` (versions in
`home/bin/agent-tools.lock`), then per repo: `no-mistakes init`, and `treehouse` when you want
parallel work. Optional, portable by copying their skill folders: Lauren Tan's `pstack`
(verification skills with a feature map, eval playbook) and the official `ralph-loop` plugin.

## Orca, when you want a workspace instead of tabs

Orca (declared cask `stablyai/orca/orca`, telemetry already off through `ORCA_TELEMETRY_DISABLED`)
runs Claude Code, Codex, Grok Build and pi side by side in its own worktrees with a diff view and a
phone companion. It is optional; herdr covers the same ground in the terminal. If you use it:

1. Launch Orca, add `~/orca/projects/dotfiles` and `~/orca/projects/brain` as projects, and fully
   restart it after `gh auth login` so its GitHub view picks up the credential.
2. Register its CLI in Settings, then in a terminal: `orca status --json` must report reachable and
   ready; `orca skills get orca-cli` and `orca skills get orchestration` load the current guides.
3. Sign into each harness once inside an Orca terminal: `claude`, `codex login`, `grok`, and `pi`
   with `/login`. Orca detects the CLIs on PATH; `agent-tools` puts pi there.
4. Leave Agent Permissions on the vendor default (bypass); `home/.grok/requirements.toml` keeps
   Grok Build's bypass enabled.
5. Clear the generic `pnpm install` worktree setup hook for dotfiles and brain (Settings, the
   repository, Worktree Hooks, Setup Script). Never put `rebuild.sh` in a hook.
6. Orca owns worktrees for the projects it manages; do not run treehouse in those repos.

## Rules that do not change with the tools

- One writer for the brain vault; other agents return drafts.
- A request authorizes its normal workflow. Purchases, messages to people, merges, deletions
  and account changes need to be named.
- Prove it: artifact, command, diff. A skipped step stays visible as "skip: reason".
- Simplify before adding machinery. Every wrapper, mode and flag needs a stated intent.
