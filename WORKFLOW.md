# One conversation, coordinated work

Orca is the workspace. One coordinator owns the request, delegates bounded tasks, checks the
results, and returns one coherent answer. Harnesses and models are replaceable workers, not the
system's identity. Start personal planning in the private brain project; keep implementation in
the target project's workspace. Do not copy personal context into public task briefs.

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
   workers can share a checkout. Isolate conflicting writes with Orca-managed worktrees; use one
   writer for brain. Do not create extra worktrees merely to make the sidebar look busy.
5. **Verify.** Execute the changed behavior, inspect the diff, and use an independent reviewer for
   consequential changes. For this repo, run the checks in `README.md`. Report failed and untested
   integrations honestly. A worker's confident summary is not proof.
6. **Remember.** The coordinator saves the useful sources, decision, outcome, and next checkpoint
   in brain. Do not build a second profile store, vector database, or role hierarchy by default.

Expand research when important uncertainty remains, not to hit a website count. A second worker
should investigate an independent question or challenge a material conclusion, not repeat the
same broad prompt. Keep broad fact collection separate from expensive final synthesis.

## Orca owns worker lifecycle

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

## HTML review, without a second platform

An HTML artifact is a decision surface, not the source of task authority. Keep personal artifacts
in brain. Prefer self-contained pages with local assets; an offline copy should remain readable.
Plain files are enough for read-only review. Lavish adds precise annotations and feedback when a
real back-and-forth review benefits from them.

Lavish is optional and runs through the declared Node toolchain, without a global npm install.
The CLI-smoke-tested release is pinned here; review a new release before changing it:

```sh
LAVISH_AXI_HOST=127.0.0.1 npm exec --yes --ignore-scripts --package=lavish-axi@0.1.64 -- lavish-axi --help
```

For an actual review, the coordinator reads the CLI's design guidance and matching playbooks,
opens the selected local file with that same pinned invocation, and keeps its feedback poll
attached while reviewing. Do not promise background monitoring without a verified wake path.
Finish or end the session explicitly. Keep generated pages and exported useful feedback or
decisions in brain, never in this public repo. Lavish's default `~/.lavish-axi` directory is
disposable local session state; cloning brain does not restore active reviews. Curate the useful
outcome before ending a review or resetting the machine, without committing session databases.
Keep `LAVISH_AXI_HOST=127.0.0.1` on server-starting invocations: the default can select Tailscale,
which would expose unauthenticated file serving to reachable peers. The version above pins the
top-level package, not every transitive dependency; it is an optional helper, not a locked Nix input.

Both Orca artifact sharing and Lavish's hosted sharing can expose content through public links.
Do not use either for private brain material by default. Local review does not require publishing.
AXI is an interface design approach, not a model router, subscription pool, memory system, or a
reason to install every wrapper in its catalog. Keep official `gh` and native Orca commands.

## Automations

One job has one scheduler, one owning account, one output destination, and one failure path.
Do not duplicate the same job in Orca, ChatGPT, Claude, and Grok Bot.

- **Local brain and project work:** prefer Orca automations. A chosen native harness runs the
  prompt in an existing workspace or a new worktree. The Mac must be awake and Orca running.
- **Grok Bot cloud work:** use Bot routines only for a separately scoped job that benefits from
  its cloud computer. This does not give it automatic access to the live local brain or Orca state.
- **Provider-specific cloud events:** use the provider's scheduler only when its supported trigger
  or connector is the reason for choosing it. Record that exception in the private job inventory.

Before enabling a job, save its purpose, inputs, scope, account, schedule/timezone, output,
duplicate-run rule, and failure notification in brain. Run the prompt manually, then create the
automation **disabled**, test Run now, inspect the result, and test the actual notification path.
Enable only after those checks pass. Keep personal prompts and automation identifiers out of
dotfiles. Use `orca automations list --json` to avoid recreating an existing schedule.

For research watches, save a dated result only when there is a useful change; return no-change
status otherwise. Use an explicit checkpoint so a retry does not duplicate notes, tasks, or
messages. Missing credentials, a changed page, or an incomplete source should produce a visible
failed/partial run, not an invented successful report. A sleeping Mac cannot send a failure at
the scheduled instant; after resume, inspect run history and report missed runs. Do not assume
automatic catch-up or notifications until those behaviors have been tested.

## Grok Bot and the memory boundary

Grok Build is a local CLI worker. Grok Bot is a separate cloud system with its own computer,
conversation history, persistent files, and routines. The same subscription does not make their
sessions or memory interchangeable. All Bots for one user share that user's cloud computer.

Keep Grok Bot as an optional research specialist, not a second chief of staff. Give it only the
minimum task packet and require dated sources, findings, and an exportable result. The coordinator
reviews and imports the result into brain. Do not clone the entire private brain onto its shared
cloud disk or treat Bot memory as authoritative.

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
- [Firstmate configuration](https://github.com/kunchenguid/firstmate/blob/8f7b79c77c2198a71a01082215227a64500015e3/docs/configuration.md)
  and [Orca adapter](https://github.com/kunchenguid/firstmate/blob/8f7b79c77c2198a71a01082215227a64500015e3/docs/orca-backend.md).
- [Lavish](https://github.com/kunchenguid/lavish-axi/blob/5b871af347444feda1d3002952ec5fc179248629/README.md)
  and [AXI](https://axi.md/).
- [Grok Bot architecture](https://docs.x.ai/grok-bot/overview) and
  [routines](https://docs.x.ai/grok-bot/skills-routines-and-automations).
- [Work/Codex shared usage](https://learn.chatgpt.com/docs/pricing) and
  [scheduled-task execution surfaces](https://learn.chatgpt.com/docs/automations).
- [Grok Bot billing and permanent account links](https://cursor.com/help/grok-bot/plans) and
  [cloud storage and cleanup boundaries](https://docs.x.ai/grok-bot/approvals-security-and-privacy).
- [Claude subscription-authenticated SDK usage](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan)
  and [Perplexity API billing](https://www.perplexity.ai/help-center/en/articles/10354847-api-payment-and-billing).
