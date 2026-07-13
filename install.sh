#!/usr/bin/env bash
# Manual installer — copies the Mobile UI skills into ~/.claude/skills/
# Prefer the plugin route instead (see README): /plugin marketplace add karemreda040-dotcom/mobile-ui
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/plugins/mobile-ui/skills"
DEST="${HOME}/.claude/skills"
STAMP="$(date +%Y%m%d-%H%M%S)"

# In the plugin layout the skills are named create/audit/fix and are namespaced by
# the plugin (/mobile-ui:create). Installed manually they land in a flat global
# namespace, so they are renamed to mobile-ui-* to stay unambiguous.
# _mobile-ui-shared keeps its name in both layouts so the ../_mobile-ui-shared/
# links inside each SKILL.md resolve identically.
PAIRS=(
  "_mobile-ui-shared:_mobile-ui-shared"
  "create:mobile-ui-create"
  "audit:mobile-ui-audit"
  "fix:mobile-ui-fix"
)

FRESH_DIR=0
[ -d "$DEST" ] || FRESH_DIR=1
mkdir -p "$DEST"

for pair in "${PAIRS[@]}"; do
  from="${pair%%:*}"
  to="${pair##*:}"

  if [ ! -d "$SRC/$from" ]; then
    echo "error: missing source directory $SRC/$from" >&2
    exit 1
  fi

  if [ -e "$DEST/$to" ]; then
    mv "$DEST/$to" "$DEST/${to}.backup-${STAMP}"
    echo "  backed up existing $to -> ${to}.backup-${STAMP}"
  fi

  cp -R "$SRC/$from" "$DEST/$to"
  echo "  installed $to"
done

echo
echo "Done. Available in every project:"
echo "  /mobile-ui-create   build a new screen or flow"
echo "  /mobile-ui-audit    read-only review of an existing UI"
echo "  /mobile-ui-fix      inspect and refactor an existing UI"

if [ "$FRESH_DIR" -eq 1 ]; then
  echo
  echo "note: ~/.claude/skills did not exist before now — restart Claude Code so it is picked up."
fi
