#!/usr/bin/env python3
"""Export the Claude plugin sources as native, self-contained Codex skills."""

from __future__ import annotations

import argparse
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "plugins" / "mobile-ui" / "skills"
SHARED = SOURCE / "_mobile-ui-shared"
SKILLS = {
    "create": ("Create Mobile UI", "Build a mobile screen or flow", "Use $mobile-ui-create to build a mobile UI for this task."),
    "audit": ("Audit Mobile UI", "Review a mobile UI without editing", "Use $mobile-ui-audit to review this mobile UI without editing files."),
    "fix": ("Fix Mobile UI", "Correct and validate a mobile UI", "Use $mobile-ui-fix to correct this mobile UI."),
}


def source_error(message: str) -> None:
    raise ValueError(f"invalid source package: {message}")


def split_frontmatter(text: str, path: Path) -> tuple[str, str]:
    if not text.startswith("---\n"):
        source_error(f"{path} has no opening frontmatter marker")
    end = text.find("\n---\n", 4)
    if end < 0:
        source_error(f"{path} has no closing frontmatter marker")
    return text[4:end], text[end + 5 :]


def description(frontmatter: str, path: Path) -> str:
    match = re.search(r"^description:\s*(.+)$", frontmatter, re.MULTILINE)
    if not match:
        source_error(f"{path} is missing a description")
    return match.group(1).strip().strip('"').strip("'")


def validate_sources() -> None:
    if not SHARED.is_dir() or (SHARED / "SKILL.md").exists():
        source_error("shared references are missing or incorrectly contain SKILL.md")
    for source_name in SKILLS:
        path = SOURCE / source_name / "SKILL.md"
        if not path.is_file():
            source_error(f"missing {path}")
        frontmatter, body = split_frontmatter(path.read_text(), path)
        description(frontmatter, path)
        if "$ARGUMENTS" not in body:
            source_error(f"{path} does not contain $ARGUMENTS")
        for target in re.findall(r"\.\./_mobile-ui-shared/([A-Za-z0-9._-]+)", body):
            if not (SHARED / target).is_file():
                source_error(f"{path} links to missing shared file {target}")


def codex_source(source_name: str) -> tuple[str, str]:
    source = SOURCE / source_name / "SKILL.md"
    frontmatter, body = split_frontmatter(source.read_text(), source)
    body = body.replace("$ARGUMENTS", "the current user task instruction and its stated constraints")
    body = body.replace("../_mobile-ui-shared/", "references/")
    body = body.replace("/mobile-ui:fix", "$mobile-ui-fix")
    if source_name == "audit":
        body = re.sub(
            r"Claude Code hosts may honor.*?available\. In addition:\n\n",
            "Treat this workflow as read-only. Use host read-only permissions when they are available. In addition:\n\n",
            body,
            count=1,
        )
    return description(frontmatter, source), body


def export(destination: Path) -> None:
    validate_sources()
    destination.mkdir(parents=True, exist_ok=True)
    targets = [destination / f"mobile-ui-{source_name}" for source_name in SKILLS]
    existing = [str(path) for path in targets if path.exists()]
    if existing:
        raise ValueError("destination already contains: " + ", ".join(existing))
    for source_name, (display_name, short_description, default_prompt) in SKILLS.items():
        skill_dir = destination / f"mobile-ui-{source_name}"
        skill_description, body = codex_source(source_name)
        skill_dir.mkdir()
        (skill_dir / "SKILL.md").write_text(f"---\nname: mobile-ui-{source_name}\ndescription: {skill_description}\n---\n\n" + body)
        shutil.copytree(SHARED, skill_dir / "references")
        agents = skill_dir / "agents"
        agents.mkdir()
        (agents / "openai.yaml").write_text(
            f'interface:\n  display_name: "{display_name}"\n  short_description: "{short_description}"\n  default_prompt: "{default_prompt}"\npolicy:\n  allow_implicit_invocation: true\n'
        )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("destination", type=Path, help="empty directory for exported skills")
    args = parser.parse_args()
    try:
        export(args.destination)
    except (OSError, ValueError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
