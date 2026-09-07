# Working with agents

Use a native GUI, a terminal, or Orca according to the work. No harness is the permanent
primary. This repository declares the tools; personal routines, account choices and project
plans live in the private brain.

## One task

1. State the intended result, constraints and an example that would prove success.
2. Use one owner for the working directory. Read the relevant project instructions and code.
3. Implement a bounded change. Inspect the diff and run checks that exercise the behavior.
4. For a substantive change, use a fresh review context with the goal, diff, nearby code and
   evidence. A finding needs a trigger, consequence and proposed fix; zero findings is valid.
5. Apply accepted fixes and check the final revision. Keep untested behavior explicit.

Unattended harness permissions are intentional. They do not turn a worktree into a security
boundary or make a rebuild restore cloud accounts and external effects. Purchases, messages
to people, merges, deletion and account changes need the exact action authorized.

## Harnesses and models

| Work | Starting choice |
| --- | --- |
| Bounded extraction, formatting, ordinary small changes | Luna xhigh |
| Implementation, synthesis and review needing more judgment | GPT Sol medium or high |
| Difficult architecture, conflicting evidence, complex debugging or Computer Use | Astra |
| Grok work | Grok Build with the available model and allowance |
| Minimal terminal harness with interchangeable providers | Pi |
| Other native GUI or CLI work | Claude Code, Codex and installed desktop apps as available |

These are defaults to adjust by task quality, latency and actual allowance. Check the current
account before long work. A chat subscription is not API credit. Use each supported sign-in
flow; do not extract native credentials into another client. Session-specific quota restrictions
belong in the private task context, not this public file.

Pi is pinned in `home/bin/agent-tools.lock`. `agent-tools pi` installs only Pi with dependency
lifecycle scripts disabled and an explicit user-local prefix. `agent-tools --list` shows the
other tools; names can be selected individually. With no arguments it installs all declared
tools for compatibility. Firstmate requires the declared AXI tools, including Lavish; Orca
remains the regular visual review surface. Installing a review CLI does not enable its daemon
or grant merge authority.

Pi loads `~/.pi/agent/AGENTS.md` from the shared `home/AGENTS.md`. Its linked settings default
to Luna xhigh and offer Sol high plus explicit OpenRouter alternatives in model cycling.
Sign in through Pi's `/login` for a supported provider. Credentials stay in `~/.pi/agent/auth.json`, outside Git. Its settings
opt out of install telemetry and analytics. Package versions are pinned; review changes before
updating them.

## Visual review in Orca

Open the project in Orca, then open a local HTML plan or the running app in its browser.
Select **Annotate page element**, click the element, add a comment and choose the target agent
from **Send**. Orca includes the element, surrounding context and styles. **Draw on screenshot**
is available for spatial feedback. Inspect the refreshed result after the agent edits the source.
Local HTML can stay on disk; public artifact sharing is a separate action.

For code, use the diff viewer and line comments. A visual annotation explains the desired
change; tests and source review establish its behavior. A review tool is optional: evaluate
no-mistakes only after an accepted architecture and working version, using a measured trial
in an appropriate repository. Do not stack permanent duplicate review loops.

Orca's embedded browser uses `orca` page commands. Native apps and external browser windows
use `orca computer`; page-only external automation can use the browser's supported driver.
Assign one input driver per app/window. For Google rejecting the default embedded profile,
use Orca's documented native-user-agent profile and sign in through the normal Google flow:

```sh
orca tab profile create --label Google --scope isolated --no-ua-spoof --json
```

Open the Google tab with the returned profile ID. Keep its cookie jar for later Google tabs.
This changes browser identification, not Google account security. Verify authenticated access
and reload persistence; a displayed login form alone does not prove the issue is fixed.
[Browser profiles](https://www.onorca.dev/docs/browser/profiles).

## Parallel work

Use Orca orchestration for supervised work: one Run, bounded Tasks, explicit `worker-start`
placement, and dispatch-matched completion. Start independent tasks before waiting. Each task
names its writable files, acceptance evidence and next owner. Workers return drafts when one
writer owns a shared document or vault. A heartbeat proves activity, not completion.

Keep workers in the existing checkout when their file ownership does not conflict. Create a
new worktree for an actual isolation need, with an explicit base and setup policy. Orca owns
worktrees in its projects; treehouse is for other repositories. Never let both manage one repo.
Release completed supervised terminals through Orca's worker lifecycle. Do not restart a live
worker merely because a wait timed out.

Ghostty and herdr remain the terminal workspace: `ctrl+b`, then `c` for a tab, `"` or `%` to
split, `h j k l` to move, `w` for workspaces. Neovim uses `space f` for files and `space g` for
Git. Use optional loop tools only for a bounded goal with a verifiable stop condition and known
billing behavior. A phone client and an always-running execution host are different things.

## Set up Orca

1. Add the actual primary clone paths, normally `~/orca/dotfiles` and `~/orca/brain`.
2. Register its CLI in Settings. Check `orca status --json`, then read the current guides with
   `orca skills get orca-cli` and `orca skills get orchestration`.
3. Sign into the harnesses you use. Orca discovers Pi through `~/.local/bin` on PATH.
4. Keep the configured permission bypass. `home/.grok/requirements.toml` preserves Grok's mode.
5. Set each repository's setup hook to its real dependency setup. Never run `rebuild.sh` as a
   worktree hook. Dotfiles and brain do not need a generic `pnpm install` hook.
6. Qualify a fresh phone request, actual connected records and result delivery before relying
   on remote or scheduled work. Local execution needs its host awake; cloud execution needs
   its own account, tools and billing route checked.

## Firstmate with pstack

Use Orca's task/dispatch records and one coordinating agent for normal work. The coordinator
chooses bounded workers, reviews their results and releases their exact terminals. Named
pstack quality skills run inside an assigned Cursor worker without another orchestrator.

Install pstack from Cursor's official Marketplace (`/add-plugin pstack` in a Cursor chat), then
use `pstack-setup --apply` from a trusted workspace to create the bounded model profile if no
rule exists. The helper preserves an existing rule. Each `--check` or `--apply` sends one small,
read-only account-backed Cursor request with a 180-second deadline. It challenges the loaded
`/technical-writing` skill using its current wording; an upstream wording change can require
updating this probe. This proves that named skill is loaded, not that every pstack workflow
works. Cached marketplace files alone are insufficient install evidence.

### Launch the pinned Firstmate distribution

`firstmate install` reconstructs the reviewed Orca compatibility history from the pinned
upstream base and checked patches in `home/share/firstmate`. It preserves ignored configuration,
backlogs and operational state. `firstmate verify` checks the exact source, configuration,
required tools and Orca readiness. Updates must remain a clean fast-forward; foreign edits
and unexpected history are refused.

Register `~/.local/share/firstmate` as an Orca project and open its primary workspace. Run
`firstmate launch` in that workspace's terminal. It enrolls the primary process, starts a
separate nonfocused supervisor daemon tab, then launches Pi on the pinned profile. It is an
explicit launch, not a login or reboot service. Before replacing that primary, run
`bin/fm-afk-launch.sh stop` from the Firstmate directory to stop its daemon and clear its
binding. Keep one primary per home.

The local distribution includes Orca task identity, control/relaunch, current-screen composer
checks, persistent secondmate ownership and guarded cleanup. Ordinary cleanup preserves dirty
and unmerged work; failed or ambiguous runtime operations retain recovery state. A confirmed
model response and an unconfirmed terminal-submit return can coexist: inspect the exact
terminal before retrying a typed command.

For a pstack worker, give Firstmate one bounded skill and deliver its native slash invocation,
such as `/technical-writing`, through `bin/fm-send.sh <task-id> '/technical-writing ...'`.
Mentioning the skill inside an encoded launch brief does not activate Cursor's parser.
Use the durable inbox for subsequent ordinary instructions and check the worker's report.

The tested profile uses subscription-backed Pi Luna xhigh for ordinary workers and Cursor
Sol High for a named pstack quality task. Other installed harnesses retain their own documented
verification status. Relay and ambient AXI hooks remain disabled. Local Orca work needs the
Mac awake; it does not by itself provide cloud or phone-off execution.

## Instructions and memory

`home/AGENTS.md` is the shared short instruction source. Each repository adds only its relevant
local knowledge in `AGENTS.md`; the root `CLAUDE.md` imports it. Skills carry conditional
procedures. Install a skill because it solves a real task, not as a generic bundle.

Brain owns durable personal context, Todoist owns tasks, Calendar owns time and 1Password
owns secrets. One writer curates the vault; other agents return sourced drafts. Record outcomes
and blockers there, never as personal session notes in this public repository.
