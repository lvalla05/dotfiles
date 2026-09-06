# One conversation, coordinated work

Grok Bot is the daily-life and mobile executive entry point. Technical work can use Codex or
Claude GUI, or the optional Orca workspace for terminal harnesses. Aside is the Mac browser;
Comet is the phone browser. One chief owns planning, delegates bounded tasks, checks the results,
and returns one coherent answer. Harnesses and models are replaceable workers, not the
system's identity. Start personal planning in the private brain project; keep implementation in
the target project's workspace. Do not copy personal context into public task briefs.

## Components with one job each

| Component | Owns | Does not own |
| --- | --- | --- |
| Grok Bot | Daily chief, cloud routines and verified service actions | Automatic access to local files or an assumed native Mac connection |
| Codex / Claude GUI | Technical tasks and native worker/project controls | A second daily-life intake or an assumed shared runtime |
| Orca, when selected | Terminal harness workers, code worktrees and project execution | A mandatory wrapper around GUI tasks or automatic managed cloud host |
| Aside | Mac browsing and qualified browser actions through its local MCP | Canonical personal memory or an assumed laptop-off runtime |
| Comet | Phone browsing | A replacement daily chief or automatic Aside sync |
| Brain / Obsidian | Portable context, evidence, decisions, outcomes | Passwords or a second agent scheduler |
| Mail, calendar, Todoist | Actual messages, commitments, and human-visible tasks | Competing copies in a new dashboard |
| 1Password / official gh | Credentials and HTTPS GitHub authentication | A per-command GitHub approval wrapper |

Notion, Slack, another orchestrator, and a custom dispatcher are not baseline dependencies.
Use them only when a demonstrated workflow needs their specific capability. A polished front
page does not make its buttons connected to these services. Existing installed apps can remain
available without each becoming a required control surface.

## Questions, research, and implementation

Use the smallest loop that answers the question:

1. **Frame.** State the decision, constraints, required evidence, and what a good result looks like.
2. **Research.** Split independent uncertainties between a few workers. Prefer primary sources;
   record dates, versions, contradictions, and what was actually tested. A useful worker returns
   findings, supporting URLs, confidence, and remaining gaps, not another unbounded research plan.
3. **Decide.** The coordinator reconciles the evidence and recommends an approach. Use a local
   HTML comparison when several alternatives or dependencies need visual review. Ordinary questions
   get an ordinary answer; they do not need a planning ceremony.
4. **Implement.** Give each worker a concrete scope and observable acceptance checks. Read-only
   workers can share a checkout. Mutating code workers use isolated worktrees in the selected tool; workers
   with overlapping writes need separate worktrees. Brain has one canonical writer and a stable
   Obsidian vault, not a different memory branch per agent.
5. **Verify.** Execute the changed behavior, inspect the diff, and use an independent reviewer for
   consequential changes. For this repo, run the checks in `README.md`. Report failed and untested
   integrations honestly. A worker's confident summary is not proof.
6. **Remember.** The coordinator saves the useful sources, decision, outcome, and next checkpoint
   in brain. Do not build a second profile store, vector database, or role hierarchy by default.

Expand research when important uncertainty remains, not to hit a website count. A second worker
should investigate an independent question or challenge a material conclusion, not repeat the
same broad prompt. Keep broad fact collection separate from expensive final synthesis.

## When using Orca

Codex and Claude GUI can manage technical tasks through their native controls. Use one lifecycle
owner per task; do not require an Orca wrapper around an existing GUI session. The instructions
in this section apply only to work delegated through Orca.

Enable Orchestration in Orca's Experimental settings if needed. Start with one generation of
workers. The current installed CLI is authoritative; load its guides rather than copying old
third-party launch commands:

```sh
orca status --json
orca skills get orca-cli
orca skills get orchestration
```

The supervised sequence is a Run, bounded Tasks, `worker-start`, then structured completion or
questions through `check`. The coordinator answers workers and verifies every result. Workers
report their exact task/dispatch outcome; the coordinator releases completed worker terminals.
Orca does not automatically decompose requests, choose concurrency, or infer file conflicts.
Those are the coordinator's job. Follow the live guide for exact arguments and recovery receipts.

Claude's Bash sandbox cannot reliably reach Orca's host runtime; macOS sandboxing can also break
`gh` TLS verification. `home/.claude/settings.json` excludes `orca *` and `gh *` from that sandbox.
Run host integration checks as standalone commands. Preserve the declared execution settings;
do not disable certificate verification or copy credentials to work around a failed check.

Test `orca status --json` from inside each selected harness, then a read-only Task with a real
`worker_done` return. Launch acceptance alone is insufficient: a harness can finish the work but
fail to reach the local Orca runtime. If that happens, inspect its transcript, record the failed
delivery, and follow the CLI's recovery receipts. Do not impersonate a worker's completion or
restart Orca while other sessions are active. A terminal taken over by the user is no longer
available for automatic cleanup.

Use the Firstmate **pattern**, not a second required runtime. The unmodified upstream distribution
has a larger mandatory toolchain and an experimental Orca adapter. It is not installed by this
repo. Reconsider it only if a concrete supervision or restart need remains unmet by native Orca.
Do not layer two task owners or two worktree managers over the same workers.

On restart, read the private checkpoint and inspect existing Runs, Tasks, Dispatches, and terminals
before launching replacements. Runtime state is operational state, not the personal knowledge
base. Export useful outcomes to brain; do not try to back up authentication databases into Git.

Worktrees are isolation, not backups. Before closing a task, inspect every changed/untracked file,
run its checks, commit useful work, push the branch with official `gh` authentication, and verify
the remote commit. Before erasing a machine, inventory `git worktree list --porcelain` and each
wanted branch's unpushed commits. Do not delete a worktree with uncommitted or unpublished work.
For this repo, advance the durable primary checkout on `main` to the accepted revision before
activation. `bootstrap.sh` and `rebuild.sh` refuse disposable linked worktrees.

## Browser and service actions

Prefer a service's supported CLI, API, or MCP for repeatable reads/writes with record IDs. Use
browser automation for authenticated websites and visual inspection; use native computer use
when the task genuinely needs a desktop app. Reuse the account's normal OAuth or 1Password login.
The agent should read back the changed record, not merely report that it clicked Save.

The Nix/Homebrew declaration installs Aside as the preferred Mac browser and browser worker.
If its account needs a missing password or recovery key, stop retries and use the supported
recovery/support route recorded in private Brain. Continue preservation and restoration with
an authenticated Chrome/Safari fallback; mark Aside **pending recovery**. Do not set its default
or qualify its MCP tools before access is resolved. After recovery, set the default through
supported settings and verify an external HTTPS link opens there. Then register its bundled CLI
through Developer settings and inspect the resolved executable path. Its documented MCP command
is `aside mcp`; register the resolved absolute path as the MCP `command` and `["mcp"]` as its
arguments with the selected harness. This avoids depending on a GUI app's PATH. Test one read-only
page inspection from the selected technical app or harness. A checked-in MCP stanza cannot prove login or tool access.
See [Aside developer interfaces](https://docs.aside.com/help/developers.md).

Keep 1Password as the credential source. For its Aside extension, open 1Password Settings > Browser
> Connect to additional browsers > Add browser and select Aside. The documented
[compatibility setup](https://docs.aside.com/help/troubleshooting#1password-extension-does-not-work)
also requires copying `~/Library/Application Support/Google/Chrome/NativeMessagingHosts/com.1password.1password.json`
to `~/Library/Application Support/Aside/NativeMessagingHosts/com.1password.1password.json` after
creating the destination directory. Inspect any existing destination before replacing it. If the
source is missing, repair Chrome's 1Password integration; do not substitute a password export.
Test a selected site's 1Password-assisted login, then a harmless authenticated read from the
harness. No raw password should appear in the transcript.

For a new local Aside setup, turn memory creation off in Settings > Memory > Configure. Preserve
any existing account memory preference unless explicitly asked to change it. Export useful task
results to brain: browser sync is not proof that task files and memory survive a reset.
See [memory controls](https://docs.aside.com/help/memory.md).

Aside's documented provider OAuth is model access inside Aside, not proof of native Codex/Claude
worker orchestration. Check account eligibility and billing in the actual login flow. Do not buy
a tier or enable API spending automatically. Its local MCP does not become a remote server merely
because a cloud agent knows the command. Phone and laptop-off limits are in `PHONE.md`.

Claude's global settings do not blanket-ban MCP messages or force every calendar write through
another confirmation. Those name-wide rules also interfere with authorized operations and can
match coordination tools. Explicit task scope still governs what may be sent or changed; a plan
or research request does not authorize mail sends, purchases, deletions, or account changes.
Apply narrower account/tool constraints where a selected connector supports them. Provider consent,
managed policy, OS prompts, and secret unlocks are separate from harness bypass. See
[Claude permission precedence](https://code.claude.com/docs/en/permission-modes).

## HTML plans and durable feedback

An HTML artifact is a decision surface, not the source of task authority. Keep personal artifacts
in brain. Prefer self-contained pages with local assets; an offline copy should remain readable.
Plain files are enough for read-only review. Interactive planning should support concrete choices,
annotations, and written feedback without requiring a separate editor.

For phone-to-Mac continuity, save submitted feedback through an authenticated service or native
form. Include the artifact version, question identifiers, choices, and a submission receipt.
Browser-local storage is a draft convenience, not durable cross-device memory. A revised artifact
does not inherit approval of an older version. The coordinator acknowledges the accepted decision
before starting its tasks; saving preferences alone does not authorize purchases or account changes.

Keep useful artifacts and exported decisions in brain, never in this public repo. Test saving on
one device, reading on another, retries, and the actual worker-result return path. A functioning
HTML preview does not establish working persistence, notifications, or agent dispatch.

Private source repositories do not make published pages private. Use verified access controls
for personal artifacts; do not expose them through public sharing links. Local read-only review
does not require publishing.
AXI is an interface design approach, not a model router, subscription pool, memory system, or a
reason to install every wrapper in its catalog. Keep official `gh` and the selected tool's supported interfaces.

## Automations

One job has one scheduler, one owning account, one output destination, and one failure path.
Do not duplicate the same job in Orca, ChatGPT, Claude, and Grok Bot.

- **Engineering project work:** use bounded jobs in the selected Codex/Claude GUI or Orca runtime.
  A worker runs the prompt in the canonical brain workspace or a code worktree. A laptop-hosted
  job requires the Mac awake and its runtime running; an always-on remote host must be configured and
  tested separately. Files, credentials, and server-side browser sessions must exist on that host.
- **Executive work:** the Grok chief owns the daily and weekly routines. Keep competing Claude,
  ChatGPT and Orca executive schedules paused. Its cloud computer does not gain automatic access
  to the live local brain or Orca state; deliver current context and verify that delivery.
- **Provider-specific cloud events:** use the provider's scheduler only when its supported trigger
  or connector is the reason for choosing it. Record that exception in the private job inventory.

Before enabling a job, save its purpose, inputs, scope, account, schedule/timezone, output,
duplicate-run rule, and failure notification in brain. Run the prompt manually, then create the
automation **disabled**, test Run now, inspect the result, and test the actual notification path.
Enable only after those checks pass. Keep personal prompts and automation identifiers out of
dotfiles. Inspect the owning scheduler's existing jobs before creating another; for Orca use
`orca automations list --json`.

For research watches, save a dated result only when there is a useful change; return no-change
status otherwise. Use an explicit checkpoint so a retry does not duplicate notes, tasks, or
messages. Missing credentials, a changed page, or an incomplete source should produce a visible
failed/partial run, not an invented successful report. A sleeping Mac cannot send a failure at
the scheduled instant; after resume, inspect run history and report missed runs. Do not assume
automatic catch-up or notifications until those behaviors have been tested.

The first useful life workflow is one daily planning turn, not many independent executives.
It reads the authorized calendar, task inbox, and relevant brain context; proposes or performs
only the specified updates; and returns the day's priorities with links to real records. An
evening reconciliation and weekly review can follow once that loop works. Keep personal targets,
health context, schedules, and routine prompts in brain. Do not activate placeholder jobs with
missing inputs just to populate an automation list.

## Grok Bot and the memory boundary

Grok Build is a local CLI worker. Grok Bot is a separate cloud system with its own computer,
conversation history, persistent files, and routines. The same subscription does not make their
sessions or memory interchangeable. All Bots for one user share that user's cloud computer.

Use one daily chief with three requests: Plan today, Capture a task, and Replan unfinished work.
Read the current private handoff before restoring it. If the user manually reset Grok Bot, rebuild
the selected chief and helpers from saved context and verify them; do not revive stale bot IDs.
Keep any engineering and maintenance helpers out of the daily entry path.
Account-specific identifiers, schedules, tested connector routes and
current context live in private brain. Deliver a dated context projection and verify its exact
contents before replacing an older one. The chief returns exportable results to brain; its
working memory is not a second canonical personal archive.

Prefer native mail and calendar connectors over signing Google into a new VM browser for every
job. A connector is usable only after an actual read or authorized write succeeds. Use a browser
route only where it is the demonstrated working adapter. Keep that session persistent and report
authentication expiry once instead of spawning repeat login attempts. Test a fresh routine run
before declaring the workflow reliable. Routine work uses an adequate inexpensive model when
the harness exposes that choice; escalate difficult judgment and engineering reviews explicitly.
Do not claim cross-vendor routing when the selected Bot tool cannot choose a model.

A native Orca-to-Bot dispatch/result API is not assumed. Confirm a supported connector or tool and
prove a harmless round trip before calling that bridge automated. A browser handoff or downloaded
report is a handoff, not a reliable unattended integration. Never extract consumer auth tokens to
simulate an undocumented API. If avoiding all persistent cloud copies is non-negotiable, use local
Grok Build instead of sending private context to Grok Bot.

Grok Bot uses Cursor account/data settings and requires cloud storage. Deleting a Bot does not
delete the shared computer's files or logins. Treat any future cleanup as separate operations.
Check the actual Grok Bot plan screen before linking subscriptions: Cursor documents the account
link as permanent, with usage on the Cursor account and optional on-demand spending. This repo
does not link accounts or enable extra spend. Do not confuse Cursor's separate Cloud Agents API
with an API for Grok Bot.

## Use subscriptions deliberately

Use native account sign-in for the harnesses included in each subscription. API keys, third-party
model routers, and external API MCP servers can create separate usage-based bills; they do not
automatically consume existing chat subscriptions. Do not enable API billing as a silent fallback.

Use a strong model for ambiguous synthesis, difficult implementation, and critical review. Use a
lighter model for bounded extraction or routine classification when it passes the same acceptance
checks. Route by capability, verified account access, remaining allowance, and task risk. Re-check
the actual model selector and usage status; do not permanently hardcode a vendor as coordinator.
Multiple workers share the provider's applicable allowance rather than multiplying it. Avoid
expensive Fast/maximum-effort settings for work that does not benefit from them.

Perplexity is useful for source discovery and an independent research pass. Verify important
claims against the cited originals. Consumer Pro and API access have separate terms; do not assume
that a Perplexity API-backed connector is covered by the paid research subscription.
Claude's current Agent SDK notice says subscription-authenticated `claude -p` and SDK usage still
draw from plan limits; the proposed separate-credit change was paused. Verify that notice again
before automating, and distinguish supported subscription authentication from an API-key login.

## References

- Live Orca references: `orca skills get orca-cli` and `orca skills get orchestration`.
- [Claude sandbox troubleshooting and host-command exclusions](https://code.claude.com/docs/en/sandboxing#troubleshooting).
- [Firstmate configuration](https://github.com/kunchenguid/firstmate/blob/8f7b79c77c2198a71a01082215227a64500015e3/docs/configuration.md)
  and [Orca adapter](https://github.com/kunchenguid/firstmate/blob/8f7b79c77c2198a71a01082215227a64500015e3/docs/orca-backend.md).
- [AXI interface principles](https://axi.md/).
- [Grok Bot architecture](https://docs.x.ai/grok-bot/overview) and
  [routines](https://docs.x.ai/grok-bot/skills-routines-and-automations).
- [Work/Codex shared usage](https://learn.chatgpt.com/docs/pricing) and
  [scheduled-task execution surfaces](https://learn.chatgpt.com/docs/automations).
- [Grok Bot billing and permanent account links](https://cursor.com/help/grok-bot/plans) and
  [cloud storage and cleanup boundaries](https://docs.x.ai/grok-bot/approvals-security-and-privacy).
- [Claude subscription-authenticated SDK usage](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan)
  and [Perplexity API billing](https://www.perplexity.ai/help-center/en/articles/10354847-api-payment-and-billing).
