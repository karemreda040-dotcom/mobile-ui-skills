#!/usr/bin/env bash
# Removes only the folders installed by install.sh. Leaves every other skill alone.
set -euo pipefail

DEST="${HOME}/.claude/skills"
OURS=(_mobile-ui-shared mobile-ui-create mobile-ui-audit mobile-ui-fix)

for name in "${OURS[@]}"; do
  if [ -d "$DEST/$name" ]; then
    rm -rf "${DEST:?}/$name"
    echo "  removed $name"
  fi
done

echo "Done. Backups (*.backup-*) were left untouched."
