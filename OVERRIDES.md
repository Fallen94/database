# Fork-local overrides

This fork tracks `Dictionarry-Hub/database` (branch `stable`) with one customization on top:

| Override | Value | Reason |
|---|---|---|
| `AV1` custom-format score in every profile YAML | `400000` (== profile `upgradeUntilScore`) | Entire library is transcoded to AV1 by Tdarr. AV1 is the terminal quality; downloads must not be replaced because of the upstream default `AV1 = -999999` (banned). |

## How sync works

`.github/workflows/upstream-sync.yml` runs weekly (Mon 04:17 UTC):

1. Fetches `upstream/stable` from `Dictionarry-Hub/database`.
2. If our fork is already ahead/equal, exits.
3. Otherwise creates a branch `sync/upstream-YYYYMMDD-HHMM`, merges upstream (favoring upstream on conflict), then re-applies overrides via `scripts/apply-overrides.sh`.
4. Opens a PR against `stable`. Review and merge.

## Adding overrides

1. Edit `scripts/apply-overrides.sh`.
2. Re-run locally: `AV1_SCORE=400000 bash scripts/apply-overrides.sh`.
3. Commit + push. Profilarr's next pull will see the new values.

**Never edit `profiles/*.yml` directly.** Direct edits survive until the next upstream sync, then get clobbered by the merge.

## Profilarr setup

In Profilarr → Settings → Repository:

- **Git Repo:** `https://github.com/Fallen94/database`
- **Branch:** `stable`
- **PAT:** GitHub fine-grained token with `Contents: read/write` on this repo (only needed if Profilarr should push commits back; for pull-only operation no PAT is required).
