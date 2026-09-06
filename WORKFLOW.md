# Working with agents

Kun Chen's five levels, sized for a student who ships a few projects a week rather than
forty PRs a day. Everything here is harness-agnostic: Claude Code, Codex, Grok Build and pi
read the same `home/AGENTS.md`, run in the same terminal, and go through the same gate.
Evidence and dates for every tool choice are in the private brain
(`Sources/Research/2026-09-06/kun-suite.md`).

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

Do not install viral skill packs. Kun Chen measured the popular "Karpathy guidelines" file on
192 ProgramBench tasks: pass rate fell 2.2 points (p = 0.005) and cost rose 5 percent. Instruction
files earn their lines from real mistakes, not from the internet.

## 3. One crewmate

1. Talk, do not type. Wispr Flow dictates into the harness; type only URLs and paths.
2. Plan in HTML. The `lavish` skill opens a plan as an annotatable page in the browser; mark
   what is wrong, pick options, send it back. Then say "build it".
3. Let it run. `cc` and `co` launch Claude Code and Codex unattended; the machine is
   reproducible and secrets sit behind 1Password and Automic Vault, so the blast radius is a
   rebuild, not a disaster.
4. Gate it. `git push no-mistakes <branch>` (or `/no-mistakes` in the session) reviews, tests,
   documents, lints, pushes, opens the PR and watches CI in a disposable worktree. Since
   version 1.64 its review prefers removing unrequested machinery over hardening it. Read the
   PR's risk line and evidence, not the diff, unless the risk is high.

## 4. Several crewmates

`treehouse` hands out clean, reusable worktrees: run it in a repo, get a fresh checkout in a
subshell, `exit` returns it to the pool. One herdr tab per crewmate; the agents panel shows who
needs you. For an overnight objective with a verifiable stop condition, `gnhf "<objective>"`
loops one small commit per iteration and waits out subscription limits instead of billing.
`quota-axi` shows every subscription's remaining window before you start something big.

Never run two worktree managers on one repo: if Orca owns a project, treehouse stays out of it.

## 5. A first mate

Firstmate (Kun's supervisor agent) needs eight tools and a dedicated session; it pays off when
three or more parallel tasks are routine. Not installed. Revisit when level 4 feels like
juggling. Grok Bot already plays the executive role for life, not code: it runs in the cloud,
holds the daily routines, and reaches the phone with the Mac closed.

## Which harness for what

| Need | Use | Why |
| --- | --- | --- |
| Interactive judgment, terse prose | Claude Code, model Opus 4.8 or Opus 5 | Opus 5 is the Max default; measured nonsense-detection and verbosity data still favor Opus 4.8 for conversation |
| Hardest decisions | Fable 5.1 as advisor or for a bounded task at high effort | On Max it is included up to half the weekly window, then metered; it is not a better all-day partner by any published measurement |
| Bulk implementation on GPT | Codex (`co`) with Luna or Terra | Luna costs a fifth of what it did in July; Astra only for the hardest agentic runs |
| Grok models | Grok Build | Included with the Grok subscription |
| Non-Claude models in one minimal harness | pi (optional, not declared) | Kun's pick. Anthropic and Google forbid subscription OAuth in third-party harnesses; use it with API keys or the OpenAI login only |
| Life, calendar, tasks, phone | Grok Bot | Cloud executive with routines and connectors |

Install the pinned CLIs once with `agent-tools` (versions in `home/bin/agent-tools.lock`),
then per repo: `no-mistakes init`, and `treehouse` when you want parallel work.
Skills: `npx skills add kunchenguid/lavish-axi --skill lavish -g` and
`npx skills add kunchenguid/quota-axi --skill quota-axi -g`.

## Rules that do not change with the tools

- One writer for the brain vault; other agents return drafts.
- A request authorizes its normal workflow. Purchases, messages to people, merges, deletions
  and account changes need to be named.
- Prove it: artifact, command, diff. A skipped step stays visible as "skip: reason".
- Simplify before adding machinery. Every wrapper, mode and flag needs a stated intent.
