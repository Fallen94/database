#!/usr/bin/env bash
# Re-applies Fallen94-fork-specific overrides on top of upstream Dictionarry-Hub/database.
# Invoked by .github/workflows/upstream-sync.yml after every upstream merge.
# Idempotent: safe to run repeatedly.
#
# Uses targeted sed (not yq) so diffs against upstream stay minimal — only the
# lines we override actually change. Direct edits to profiles/*.yml are
# clobbered on every upstream sync; do all customization here.

set -euo pipefail

AV1_SCORE="${AV1_SCORE:-400000}"

echo "[overrides] AV1 score -> ${AV1_SCORE} across profiles/*.yml"
for f in profiles/*.yml; do
  [ -f "$f" ] || continue
  if ! grep -q '^- name: AV1$' "$f"; then
    echo "[overrides]   skip $f (no AV1 entry)"
    continue
  fi
  sed -i "/^- name: AV1\$/{n;s/^  score: -\?[0-9][0-9]*\$/  score: ${AV1_SCORE}/}" "$f"
done

echo "[overrides] done"
