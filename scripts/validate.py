#!/usr/bin/env python3
"""Structural check for the mobile-ui plugin. Standard library only."""

import json
import re
import sys
import tempfile
from pathlib import Path
import importlib.util

ROOT = Path(__file__).resolve().parent.parent
PLUGIN = ROOT / "plugins" / "mobile-ui"
SKILLS = PLUGIN / "skills"
SHARED = SKILLS / "_mobile-ui-shared"

VISIBLE_SKILLS = ["create", "audit", "fix"]
SHARED_FILES = [
    "FOUNDATIONS.md", "COMPONENTS.md", "PLATFORM-IOS.md", "PLATFORM-ANDROID.md",
    "ARABIC-RTL.md", "ANTI-AI.md", "REVIEW-CHECKLIST.md", "EVALS.md",
    "SOURCES.md", "TOKENS.json",
]
MAX_SKILL_LINES = 500

errors = []
warnings = []


def split_frontmatter(text, where):
    """Return the raw frontmatter block and the body, or (None, text) on failure."""
    if not text.startswith("---\n"):
        errors.append(f"{where}: missing opening '---' frontmatter marker")
        return None, text
    end = text.find("\n---\n", 3)
    if end == -1:
        errors.append(f"{where}: missing closing '---' frontmatter marker")
        return None, text
    return text[4:end], text[end + 5:]


def parse_scalars(block):
    """Minimal top-level `key: value` reader. Enough for our flat frontmatter."""
    out = {}
    for line in block.splitlines():
        if not line or line.startswith((" ", "\t", "#")):
            continue
        m = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if m:
            out[m.group(1)] = m.group(2).strip().strip('"').strip("'")
    return out


# --- plugin + marketplace manifests -----------------------------------------
for manifest, required in (
    (ROOT / ".claude-plugin" / "marketplace.json", ("name", "owner", "plugins")),
    (PLUGIN / ".claude-plugin" / "plugin.json", ("name", "version", "description")),
):
    if not manifest.exists():
        errors.append(f"missing {manifest.relative_to(ROOT)}")
        continue
    try:
        data = json.loads(manifest.read_text())
    except json.JSONDecodeError as exc:
        errors.append(f"{manifest.relative_to(ROOT)}: invalid JSON — {exc}")
        continue
    for key in required:
        if key not in data:
            errors.append(f"{manifest.relative_to(ROOT)}: missing required key '{key}'")

# --- shared reference folder -------------------------------------------------
if (SHARED / "SKILL.md").exists():
    errors.append("_mobile-ui-shared must NOT contain SKILL.md (it would become a 4th command)")

for name in SHARED_FILES:
    if not (SHARED / name).exists():
        errors.append(f"_mobile-ui-shared: missing {name}")

tokens = SHARED / "TOKENS.json"
if tokens.exists():
    try:
        json.loads(tokens.read_text())
    except json.JSONDecodeError as exc:
        errors.append(f"TOKENS.json: invalid JSON — {exc}")

# --- each visible skill ------------------------------------------------------
for skill in VISIBLE_SKILLS:
    path = SKILLS / skill / "SKILL.md"
    where = f"skills/{skill}/SKILL.md"

    if not path.exists():
        errors.append(f"missing {where}")
        continue

    text = path.read_text()
    n_lines = len(text.splitlines())
    if n_lines >= MAX_SKILL_LINES:
        errors.append(f"{where}: {n_lines} lines — must stay under {MAX_SKILL_LINES}")

    block, body = split_frontmatter(text, where)
    if block is None:
        continue
    fm = parse_scalars(block)

    # `name` is intentionally omitted so the command name follows the directory:
    # /mobile-ui:create as a plugin, /mobile-ui-create when installed manually.
    if "name" in fm:
        errors.append(f"{where}: must NOT set 'name' — it breaks the dual plugin/manual layout")

    for key in ("description", "argument-hint"):
        if not fm.get(key):
            errors.append(f"{where}: '{key}' is missing or empty")

    if fm.get("disable-model-invocation") != "true":
        errors.append(f"{where}: 'disable-model-invocation: true' is required")

    if "$ARGUMENTS" not in body:
        errors.append(f"{where}: body must reference $ARGUMENTS")

    # The audit skill must actually be read-only. allowed-tools does NOT restrict;
    # only disallowed-tools removes tools from the pool.
    if skill == "audit":
        blocked = fm.get("disallowed-tools", "")
        for tool in ("Edit", "Write", "NotebookEdit"):
            if tool not in blocked:
                errors.append(f"{where}: read-only audit must disallow '{tool}' via disallowed-tools")
    if "allowed-tools" in fm:
        warnings.append(f"{where}: 'allowed-tools' only PRE-APPROVES tools, it does not restrict them")

    # every ../_mobile-ui-shared/X link must resolve
    for target in re.findall(r"\.\./_mobile-ui-shared/([A-Za-z0-9._-]+)", text):
        if not (SHARED / target).exists():
            errors.append(f"{where}: broken shared link -> _mobile-ui-shared/{target}")

# --- installers --------------------------------------------------------------
for script in ("install.sh", "uninstall.sh"):
    if not (ROOT / script).exists():
        errors.append(f"missing {script}")

# --- native Codex export -----------------------------------------------------
exporter_path = ROOT / "scripts" / "export_codex_skills.py"
if not exporter_path.exists():
    errors.append("missing scripts/export_codex_skills.py")
else:
    spec = importlib.util.spec_from_file_location("export_codex_skills", exporter_path)
    exporter = importlib.util.module_from_spec(spec)
    try:
        assert spec.loader is not None
        spec.loader.exec_module(exporter)
        with tempfile.TemporaryDirectory(prefix="mobile-ui-codex-export-") as temp:
            exported = Path(temp)
            exporter.export(exported)
            for skill in VISIBLE_SKILLS:
                name = f"mobile-ui-{skill}"
                skill_dir = exported / name
                skill_file = skill_dir / "SKILL.md"
                if not skill_file.exists():
                    errors.append(f"Codex export: missing {name}/SKILL.md")
                    continue
                block, body = split_frontmatter(skill_file.read_text(), f"Codex export {name}/SKILL.md")
                fm = parse_scalars(block or "")
                if set(fm) != {"name", "description"} or fm.get("name") != name:
                    errors.append(f"Codex export: {name} must have only name and description frontmatter")
                if "$ARGUMENTS" in body or "/mobile-ui:" in body:
                    errors.append(f"Codex export: {name} contains an unresolved host-specific invocation")
                if skill == "audit" and ("Claude Code" in body or "tools are removed" in body):
                    errors.append(f"Codex export: audit contains a Claude-only enforcement claim")
                for target in re.findall(r"references/([A-Za-z0-9._-]+)", body):
                    if not (skill_dir / "references" / target).exists():
                        errors.append(f"Codex export: {name} has broken reference {target}")
                metadata = skill_dir / "agents" / "openai.yaml"
                if not metadata.exists() or "allow_implicit_invocation: true" not in metadata.read_text():
                    errors.append(f"Codex export: {name} is missing implicit-invocation metadata")
    except (OSError, ValueError, ImportError) as exc:
        errors.append(f"Codex export failed: {exc}")

# --- report ------------------------------------------------------------------
for w in warnings:
    print(f"warning: {w}")

if errors:
    print()
    for e in errors:
        print(f"FAIL: {e}")
    print(f"\n{len(errors)} error(s).")
    sys.exit(1)

print("Validation passed.")
print(f"  plugin:   mobile-ui")
print(f"  skills:   {', '.join(VISIBLE_SKILLS)}  (+ _mobile-ui-shared, {len(SHARED_FILES)} reference files)")
print(f"  commands: /mobile-ui:create  /mobile-ui:audit  /mobile-ui:fix")
