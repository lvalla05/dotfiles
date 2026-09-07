# Working with agents

Use Codex with Astra or Claude Code with Fable as the main task owner. Switch the owner
when switching harnesses; retain the same project files and a concise handoff. Pi, tmux,
Cursor and Orca support specific needs. These defaults can change with demonstrated quality.
This repository declares tools and operating conventions; personal plans live in private Brain.

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
| Substantial implementation and project work | Codex, Astra medium; high for harder judgment |
| Alternate implementation, editorial work and consequential review | Claude Code, Fable high |
| Fast research and independent alternatives | Gemini through an available supported surface |
| Authenticated web work and X research | Aside CLI or MCP, using the intended browser host |
| Minimal terminal harness or another provider | Pi; Astra medium default, explicit model cycling |
| Persistent terminal process | tmux in the existing terminal workspace |
| Visual code editing, named pstack skills or cloud workers | Cursor when that capability is needed |
| Explicit multi-worktree supervision | Orca when the work benefits from it |

These are defaults to adjust by task quality, latency and actual allowance. Check the current
account before long work. A chat subscription is not API credit. Use each supported sign-in
flow; do not extract native credentials into another client. Session-specific quota restrictions
belong in the private task context, not this public file.

Pi is pinned in `home/bin/agent-tools.lock`. `agent-tools pi` installs only Pi with dependency
lifecycle scripts disabled and an explicit user-local prefix. `agent-tools --list` shows the
other tools; names can be selected individually. With no arguments it installs all declared
tools for compatibility. Firstmate requires the declared AXI tools, including Lavish; Orca
remains an optional visual review surface. Installing a review CLI does not enable its daemon
or grant merge authority.

Pi loads `~/.pi/agent/AGENTS.md` from the shared `home/AGENTS.md`. Its linked settings default
to Astra medium and retain Sol high, Luna xhigh and explicit OpenRouter alternatives in model cycling.
Sign in through Pi's `/login` for a supported provider. Credentials stay in `~/.pi/agent/auth.json`, outside Git. Its settings
opt out of install telemetry and analytics. Package versions are pinned; review changes before
updating them.

## Signed-in browsing with Aside

The Aside application is declared in `configuration.nix`. Enable its CLI from the app and
use `aside guide` for the installed version. The shared `aside-browser` skill is linked into
Codex, Claude Code and Pi discovery paths by `home.nix`; it contains the host and session
rules rather than a copied browser manual. `aside host list` identifies available hosts.
Verify the intended browser before using `aside host use <host>` to persist a default.

The Codex activation helper adds `aside mcp` only when no Aside server is configured, preserving
an existing host/account choice. Register Claude Code's user-scoped server once:

```sh
claude mcp add --scope user aside -- "$HOME/.local/bin/aside" mcp
```

The two interfaces share one browser. Use a site API or semantic page action where supported;
keep one driver per tab. A one-shot REPL can close its temporary session and tabs, so retain
an interactive REPL process for a multi-step workflow. Verify submission and final state.
Native computer control is for an actual app/window requirement.

## Native computer use and Figma

In the native ChatGPT/Codex app, use its official Computer use plugin and runtime. Verify
Computer use is enabled in Settings and grant the requested macOS permissions through the
normal system dialogs. Inspect the target window after each action. The shared Orca
`computer-use` skill describes a different controller; it must not route a native session
back through Orca. Disable that specific skill folder with a `skills.config` override in
the native Codex config; keep the native Computer use plugin enabled. Use one controller
per window and Aside for supported page operations.
[Native computer use](https://learn.chatgpt.com/docs/computer-use).

Install the official Figma plugins in each harness's own configuration:

```sh
codex plugin add figma@openai-curated-remote
claude plugin install figma@claude-plugins-official
```

Complete the Figma connection in the native app's Plugins settings, and authenticate the
Claude plugin's server through `/mcp` in a fresh Claude session. Installation alone does not
prove account access. Check identity, team and seat with the plugin, then create a small
editable design and read it back before relying on canvas writes. Use the official skills
for reusable components, layouts and implementation; use computer control to inspect the
actual result. Write access requires a suitable Full seat; do not silently purchase one.
[Figma setup](https://developers.figma.com/docs/figma-mcp-server/remote-server-installation/).

## Continue from a phone

For native Codex work, pair ChatGPT mobile with ChatGPT desktop: Settings → Connections →
Control this Mac → Add, then scan and approve on the phone using the same account/workspace.
Verify a real phone-originated task and its result. Keep the Mac awake, online and the app
running; the app offers an awake-while-plugged-in setting. A sleeping laptop cannot execute
local work. Pairing uses the native relay and does not require Orca or a separate SSH/VPN
setup. [Remote connections](https://learn.chatgpt.com/docs/remote-connections).

For Claude Code, use `/remote-control` in the existing interactive session or launch
`claude remote-control --spawn=session` from the intended project. Connect through Claude
mobile or claude.ai/code. Keep that local process running; tmux can preserve it when a
terminal window closes, but cannot make the Mac work through sleep or reboot. Switch the
task owner before starting another writer. A cloud Claude session has a separate execution
environment. [Claude Remote Control](https://code.claude.com/docs/en/remote-control).

## Visual review in Orca (optional)

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

Use native subagents for bounded independent work when they fit. When Orca owns a supervised
run, use one Run, bounded Tasks, explicit `worker-start` placement and matched completion. Start independent tasks before waiting. Each task
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

Firstmate is an optional, explicitly launched distribution. It is not a prerequisite for
native Codex or Claude Code. When used, its coordinator owns dispatch, integration and worker
cleanup. Named pstack quality skills run inside an assigned Cursor worker.

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

The pinned Firstmate profile was qualified with subscription-backed Pi Luna xhigh and Cursor
Sol High for a named pstack task. That explicit profile is separate from the current Pi
interactive default; changing one does not qualify the other. Other installed harnesses retain their own documented
verification status. Relay and ambient AXI hooks remain disabled. Local Orca work needs the
Mac awake; it does not by itself provide cloud or phone-off execution.

## Switching the task owner

Pause the current writer, inspect its uncommitted diff and record the intended result,
current branch/folder, changed files, completed checks and remaining work. Resume the next
harness in that same folder. A new harness does not inherit another provider's conversation;
project files and the handoff carry the state. Keep private handoffs in Brain, not this repo.
Use a native session ID for same-harness continuation instead of starting from scratch.

A tmux session survives a terminal window closing, not a server crash, reboot or Mac sleep.
Remote Control requires the actual host awake and reachable. Cloud execution has a separate
filesystem, credentials and result-delivery path; qualify it with a real task before relying
on phone-only operation. Do not add a second memory database to bridge the two.

## Instructions and memory

`home/AGENTS.md` is the shared short instruction source. Each repository adds only its relevant
local knowledge in `AGENTS.md`; the root `CLAUDE.md` imports it. Skills carry conditional
procedures. Install a skill because it solves a real task, not as a generic bundle.

Brain owns durable personal context, Todoist owns tasks, Calendar owns time and 1Password
owns secrets. One writer curates the vault; other agents return sourced drafts. Record outcomes
and blockers there, never as personal session notes in this public repository.
