#!/usr/bin/env python3
"""Isolated lifecycle tests; never use a real agent skill directory."""

from __future__ import annotations

import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
INSTALL = ROOT / "install.sh"
UNINSTALL = ROOT / "uninstall.sh"


def run(*args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, cwd=ROOT, text=True, capture_output=True, check=True)


class InstallerTests(unittest.TestCase):
    def test_invalid_arguments_do_not_create_destinations(self) -> None:
        with tempfile.TemporaryDirectory(prefix="mobile-ui-installer-") as temp:
            dest = Path(temp) / "should-not-exist"
            result = subprocess.run(
                ["bash", str(INSTALL), "--agent", "both", "--dest", str(dest)],
                cwd=ROOT, text=True, capture_output=True,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(dest.exists())
            result = subprocess.run(
                ["bash", str(UNINSTALL), "--agent"],
                cwd=ROOT, text=True, capture_output=True,
            )
            self.assertNotEqual(result.returncode, 0)

    def test_codex_install_reinstall_and_uninstall_preserves_unrelated(self) -> None:
        with tempfile.TemporaryDirectory(prefix="mobile-ui-installer-") as temp:
            dest = Path(temp) / ".agents" / "skills"
            dest.mkdir(parents=True)
            unrelated = dest / "unrelated-skill"
            unrelated.mkdir()
            (unrelated / "keep.txt").write_text("keep")

            run("bash", str(INSTALL), "--agent", "codex", "--dest", str(dest))
            for name in ("mobile-ui-create", "mobile-ui-audit", "mobile-ui-fix"):
                skill = dest / name
                text = (skill / "SKILL.md").read_text()
                self.assertIn(f"name: {name}", text)
                self.assertNotIn("$ARGUMENTS", text)
                self.assertNotIn("/mobile-ui:", text)
                self.assertTrue((skill / "references" / "ANTI-AI.md").is_file())
                self.assertIn("allow_implicit_invocation: true", (skill / "agents" / "openai.yaml").read_text())
            self.assertNotIn("Claude Code", (dest / "mobile-ui-audit" / "SKILL.md").read_text())

            (dest / "mobile-ui-create" / "sentinel.txt").write_text("replaced")
            run("bash", str(INSTALL), "--agent", "codex", "--dest", str(dest))
            self.assertFalse((dest / "mobile-ui-create" / "sentinel.txt").exists())
            backups = list(dest.parent.glob(".mobile-ui-skills-backup.codex.*"))
            self.assertTrue(any((backup / "mobile-ui-create" / "sentinel.txt").exists() for backup in backups))

            run("bash", str(UNINSTALL), "--agent", "codex", "--dest", str(dest))
            self.assertTrue((unrelated / "keep.txt").is_file())
            self.assertTrue(all(not (dest / name).exists() for name in ("mobile-ui-create", "mobile-ui-audit", "mobile-ui-fix")))

    def test_claude_install_stays_backward_compatible(self) -> None:
        with tempfile.TemporaryDirectory(prefix="mobile-ui-installer-") as temp:
            dest = Path(temp) / "skills"
            run("bash", str(INSTALL), "--dest", str(dest))
            self.assertTrue((dest / "_mobile-ui-shared" / "TOKENS.json").is_file())
            self.assertIn("$ARGUMENTS", (dest / "mobile-ui-create" / "SKILL.md").read_text())
            run("bash", str(UNINSTALL), "--dest", str(dest))
            self.assertFalse((dest / "mobile-ui-create").exists())


if __name__ == "__main__":
    unittest.main()
