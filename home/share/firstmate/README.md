# Firstmate source distribution

`home/bin/firstmate` installs the upstream revision in `agent-tools.lock`, then reconstructs the compatibility commits recorded in `orca.lock.json`. Each patch has a SHA-256 checksum; every reconstructed tree and commit must match the manifest. Installation fast-forwards an existing clean source checkout and preserves ignored operational configuration, reports, and credentials.

`history` contains earlier compatibility releases in parent order. `orca.patch` applies to the last historical revision, or to `baseRevision` when history is empty. Keep published history immutable so existing installations can fast-forward. Each commit uses the fixed metadata and message in `prepare_compatibility_step` in the installer.

The compatibility changes add Orca lifecycle, process identity, persistent secondmate, and supervisor support. Run `firstmate verify` before launch. `firstmate launch` starts supervision and the Pi primary inside the registered Firstmate Orca workspace. See [WORKFLOW.md](../../../WORKFLOW.md) for operation and shutdown.
