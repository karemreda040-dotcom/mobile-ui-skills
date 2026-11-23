#!/usr/bin/env bash
# Install Mobile UI Skills for Claude Code, Codex, or both.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SOURCE="$ROOT/plugins/mobile-ui/skills"
CODEX_EXPORTER="$ROOT/scripts/export_codex_skills.py"
AGENT="claude"
DEST=""
CLAUDE_STAGE=""
CODEX_STAGE=""

usage() {
  cat <<'EOF'
Usage: bash install.sh [--agent claude|codex|both] [--dest PATH]

Defaults to --agent claude for backwards compatibility.
--dest is supported for one agent only and is useful for project-local or test installs.
Default destinations: ~/.claude/skills and ~/.agents/skills.
EOF
}
cleanup() { [ -z "$CLAUDE_STAGE" ] || rm -rf "$CLAUDE_STAGE"; [ -z "$CODEX_STAGE" ] || rm -rf "$CODEX_STAGE"; }
trap cleanup EXIT

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

prepare_claude() {
  local parent name
  [ -d "$CLAUDE_SOURCE/_mobile-ui-shared" ] || { echo "error: missing Claude source files" >&2; return 1; }
  for name in _mobile-ui-shared create audit fix; do [ -d "$CLAUDE_SOURCE/$name" ] || { echo "error: missing $CLAUDE_SOURCE/$name" >&2; return 1; }; done
  parent="$(dirname "${DEST:-$HOME/.claude/skills}")"; mkdir -p "$parent"
  CLAUDE_STAGE="$(mktemp -d "$parent/.mobile-ui-skills-stage.XXXXXX")"
  cp -R "$CLAUDE_SOURCE/_mobile-ui-shared" "$CLAUDE_STAGE/_mobile-ui-shared"
  cp -R "$CLAUDE_SOURCE/create" "$CLAUDE_STAGE/mobile-ui-create"
  cp -R "$CLAUDE_SOURCE/audit" "$CLAUDE_STAGE/mobile-ui-audit"
  cp -R "$CLAUDE_SOURCE/fix" "$CLAUDE_STAGE/mobile-ui-fix"
}

prepare_codex() {
  local parent
  [ -f "$CODEX_EXPORTER" ] || { echo "error: missing Codex exporter" >&2; return 1; }
  command -v python3 >/dev/null || { echo "error: python3 is required for Codex installation" >&2; return 1; }
  parent="$(dirname "${DEST:-$HOME/.agents/skills}")"; mkdir -p "$parent"
  CODEX_STAGE="$(mktemp -d "$parent/.mobile-ui-skills-stage.XXXXXX")"
  python3 "$CODEX_EXPORTER" "$CODEX_STAGE"
}

install_stage() {
  local stage="$1" destination="$2" agent_name="$3"; shift 3
  local parent backup="" name
  parent="$(dirname "$destination")"; mkdir -p "$destination"
  for name in "$@"; do
    if [ -e "$destination/$name" ] || [ -L "$destination/$name" ]; then
      if [ -z "$backup" ]; then backup="$(mktemp -d "$parent/.mobile-ui-skills-backup.${agent_name}.XXXXXX")"; fi
      mv "$destination/$name" "$backup/$name"
    fi
    mv "$stage/$name" "$destination/$name"
    echo "  installed $agent_name skill $name"
  done
  [ -z "$backup" ] || echo "  backups: $backup"
}

# Build every requested payload before mutating either destination. For a dual
# install, export Codex first so its Python/source preflight cannot partially
# install the Claude payload.
if [ "$AGENT" = "codex" ] || [ "$AGENT" = "both" ]; then prepare_codex; fi
if [ "$AGENT" = "claude" ] || [ "$AGENT" = "both" ]; then prepare_claude; fi
if [ "$AGENT" = "claude" ] || [ "$AGENT" = "both" ]; then install_stage "$CLAUDE_STAGE" "${DEST:-$HOME/.claude/skills}" claude _mobile-ui-shared mobile-ui-create mobile-ui-audit mobile-ui-fix; rmdir "$CLAUDE_STAGE"; CLAUDE_STAGE=""; fi
if [ "$AGENT" = "codex" ] || [ "$AGENT" = "both" ]; then install_stage "$CODEX_STAGE" "${DEST:-$HOME/.agents/skills}" codex mobile-ui-create mobile-ui-audit mobile-ui-fix; rmdir "$CODEX_STAGE"; CODEX_STAGE=""; fi
