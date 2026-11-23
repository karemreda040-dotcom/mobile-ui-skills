#!/usr/bin/env bash
# Remove only named Mobile UI Skill directories; unrelated skills remain untouched.
set -euo pipefail

AGENT="claude"
DEST=""
usage() { echo "Usage: bash uninstall.sh [--agent claude|codex|both] [--dest PATH]"; }
while [ "$#" -gt 0 ]; do
  case "$1" in
    --agent|--dest)
      [ "$#" -ge 2 ] && [ -n "$2" ] || { echo "error: $1 requires a value" >&2; exit 2; }
      if [ "$1" = "--agent" ]; then AGENT="$2"; else DEST="$2"; fi
      shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "error: unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done
case "$AGENT" in claude|codex|both) ;; *) echo "error: --agent must be claude, codex, or both" >&2; exit 2 ;; esac
if [ -n "$DEST" ] && [ "$AGENT" = "both" ]; then echo "error: --dest may only be used with one agent" >&2; exit 2; fi

remove_from() {
  local destination="$1"; shift
  for name in "$@"; do
    if [ -d "$destination/$name" ] || [ -L "$destination/$name" ]; then
      rm -rf "$destination/$name"
      echo "  removed $name"
    fi
  done
}
if [ "$AGENT" = "claude" ] || [ "$AGENT" = "both" ]; then remove_from "${DEST:-$HOME/.claude/skills}" _mobile-ui-shared mobile-ui-create mobile-ui-audit mobile-ui-fix; fi
if [ "$AGENT" = "codex" ] || [ "$AGENT" = "both" ]; then remove_from "${DEST:-$HOME/.agents/skills}" mobile-ui-create mobile-ui-audit mobile-ui-fix; fi
echo "Done. Unrelated skills and installer backups were left untouched."
