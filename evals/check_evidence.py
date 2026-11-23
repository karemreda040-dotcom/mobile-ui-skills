#!/usr/bin/env python3
"""Validate the checked-in baseline evidence package without external tools."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def fail(errors: list[str], message: str) -> None:
    errors.append(message)


def validate_followup_scorecard(run: Path, rubric_criteria: set[str], errors: list[str]) -> None:
    followup = run / "followup"
    scorecard_path = next(
        (path for path in (followup / "grading-followup-final.json", followup / "grading-followup.json") if path.is_file()),
        None,
    )
    if scorecard_path is not None:
        try:
            scorecard = load(scorecard_path)
        except (OSError, json.JSONDecodeError) as exc:
            fail(errors, f"cannot load follow-up scorecard: {exc}")
            scorecard = None
        if scorecard is not None:
            scenarios = scorecard.get("scenarios") or scorecard.get("scored_scenarios") or []
            records = [criterion["id"] for scenario in scenarios for criterion in scenario.get("criteria", [])]
            ids = set(records)
            if len(records) != 44 or len(ids) != 44 or ids != rubric_criteria:
                fail(errors, "follow-up scorecard must contain the exact 44 unique rubric criteria")
            if scorecard.get("pending_scenarios"):
                fail(errors, "follow-up scorecard still has pending scenarios")
            scenario_scores = []
            for scenario in scenarios:
                criteria = scenario.get("criteria", [])
                invalid = [c.get("id") for c in criteria if c.get("score") not in (0, 1, 2)]
                if invalid:
                    fail(errors, f"follow-up scenario {scenario.get('id')} has invalid scores: {invalid}")
                calculated = sum(c.get("score", -1) for c in criteria)
                maximum = len(criteria) * 2
                if scenario.get("score") != calculated:
                    fail(errors, f"follow-up scenario {scenario.get('id')} score is {scenario.get('score')}, expected {calculated}")
                if scenario.get("maximum") != maximum:
                    fail(errors, f"follow-up scenario {scenario.get('id')} maximum is {scenario.get('maximum')}, expected {maximum}")
                scenario_scores.append((calculated, maximum))
            raw = scorecard.get("raw_score")
            maximum = scorecard.get("maximum_score")
            subtotal = scorecard.get("subtotal") or {}
            overall = scorecard.get("overall_total") or {}
            if raw is None:
                raw = subtotal.get("score", overall.get("score"))
            if maximum is None:
                maximum = subtotal.get("maximum", overall.get("maximum"))
            if raw is not None and raw != sum(score for score, _ in scenario_scores):
                fail(errors, "follow-up raw score does not equal scenario subtotals")
            if maximum is not None and maximum != sum(maximum for _, maximum in scenario_scores):
                fail(errors, "follow-up maximum score does not equal scenario maxima")
            if raw is None or maximum is None:
                fail(errors, "follow-up scorecard has no complete raw/max total")
            elif scorecard.get("percent", subtotal.get("percent", overall.get("percent"))) != round(raw / maximum * 100, 2):
                fail(errors, "follow-up percentage does not match raw/max total")

    manifest = followup / "followup-artifact-hashes.json"
    if manifest.is_file():
        try:
            hashes = load(manifest)
        except (OSError, json.JSONDecodeError) as exc:
            fail(errors, f"cannot load follow-up artifact hashes: {exc}")
            hashes = {}
        for relative, expected in (hashes.get("files", hashes)).items():
            path = followup / relative
            if not path.is_file():
                fail(errors, f"missing follow-up artifact: {relative}")
            elif sha256(path) != expected:
                fail(errors, f"follow-up artifact hash mismatch: {relative}")


def main() -> int:
    run = Path(sys.argv[1]) if len(sys.argv) == 2 else Path(__file__).parent / "runs" / "2026-11-23"
    baseline = run / "baseline"
    errors: list[str] = []

    try:
        rubric = load(baseline / "rubric.json")
        scorecard = load(baseline / "grading-baseline.json")
        artifact_hashes = load(baseline / "baseline-artifact-hashes.json")
        fixture_hashes = load(baseline / "fixture-hashes.json")
    except (OSError, json.JSONDecodeError) as exc:
        print(f"FAIL: cannot load evidence JSON: {exc}")
        return 1

    rubric_records = [
        criterion["id"]
        for scenario in rubric.get("scenarios", [])
        for criterion in scenario.get("criteria", [])
    ]
    rubric_criteria = set(rubric_records)
    if len(rubric_records) != 44 or len(rubric_criteria) != 44:
        fail(errors, f"rubric must contain exactly 44 criterion records with unique IDs; found {len(rubric_records)} records and {len(rubric_criteria)} IDs")

    score_records = [
        criterion["id"]
        for scenario in scorecard.get("scenarios", [])
        for criterion in scenario.get("criteria", [])
    ]
    score_criteria = set(score_records)
    if len(score_records) != 44 or len(score_criteria) != 44:
        fail(errors, f"scorecard must contain exactly 44 criterion records with unique IDs; found {len(score_records)} records and {len(score_criteria)} IDs")
    if score_criteria != rubric_criteria:
        fail(errors, "scorecard criteria IDs do not exactly match rubric criteria IDs")

    scenario_scores = []
    for scenario in scorecard.get("scenarios", []):
        criteria = scenario.get("criteria", [])
        invalid = [c["id"] for c in criteria if c.get("score") not in (0, 1, 2)]
        if invalid:
            fail(errors, f"scenario {scenario.get('id')} has scores outside 0/1/2: {invalid}")
        calculated = sum(c.get("score", -1) for c in criteria)
        maximum = len(criteria) * 2
        if scenario.get("score") != calculated:
            fail(errors, f"scenario {scenario.get('id')} score is {scenario.get('score')}, expected {calculated}")
        if scenario.get("maximum") != maximum:
            fail(errors, f"scenario {scenario.get('id')} maximum is {scenario.get('maximum')}, expected {maximum}")
        scenario_scores.append((calculated, maximum))

    raw = sum(score for score, _ in scenario_scores)
    maximum = sum(maximum for _, maximum in scenario_scores)
    expected_percent = round(raw / maximum * 100, 2) if maximum else 0.0
    if scorecard.get("raw_score") != raw:
        fail(errors, f"raw_score is {scorecard.get('raw_score')}, expected {raw}")
    if scorecard.get("maximum_score") != maximum:
        fail(errors, f"maximum_score is {scorecard.get('maximum_score')}, expected {maximum}")
    if scorecard.get("percent") != expected_percent:
        fail(errors, f"percent is {scorecard.get('percent')}, expected {expected_percent}")

    for relative, expected in artifact_hashes.items():
        path = baseline / relative
        if not path.is_file():
            fail(errors, f"missing baseline artifact: {relative}")
        elif sha256(path) != expected:
            fail(errors, f"baseline artifact hash mismatch: {relative}")

    for fixture_name, files in fixture_hashes.items():
        for relative, expected in files.items():
            path = baseline / "fixtures" / fixture_name / relative
            if not path.is_file():
                fail(errors, f"missing fixture input: {fixture_name}/{relative}")
            elif sha256(path) != expected:
                fail(errors, f"fixture input hash mismatch: {fixture_name}/{relative}")

    # Scenario 2 is the read-only audit input; ensure the copied audit fixture is unchanged.
    scenario_two = fixture_hashes.get("scenario-2", {})
    scenario_two_dir = baseline / "scenario-2"
    actual_scenario_two = {
        str(path.relative_to(scenario_two_dir))
        for path in scenario_two_dir.rglob("*")
        if path.is_file()
    }
    if actual_scenario_two != set(scenario_two):
        fail(errors, "scenario-2 audit input file set differs from fixture-hashes.json")
    for relative, expected in scenario_two.items():
        path = scenario_two_dir / relative
        if not path.is_file():
            fail(errors, f"missing scenario-2 audit input: {relative}")
        elif sha256(path) != expected:
            fail(errors, f"scenario-2 audit input changed: {relative}")

    if not (baseline / "scenario-1/assets/fonts/Cairo-Variable.ttf").is_file():
        fail(errors, "missing essential Cairo font fixture")
    if not (baseline / "scenario-1/assets/fonts/OFL.txt").is_file():
        fail(errors, "missing Cairo font OFL provenance")

    validate_followup_scorecard(run, rubric_criteria, errors)

    if errors:
        print("Evidence check failed:")
        print("\n".join(f"- {error}" for error in errors))
        return 1

    print(f"Evidence check passed: {len(rubric_criteria)} criteria, {len(artifact_hashes)} baseline artifacts, raw {raw}/{maximum} ({expected_percent:.2f}%).")
    followup_path = run / "followup" / "grading-followup.json"
    if followup_path.is_file():
        followup = load(followup_path)
        total = followup.get("overall_total") or followup.get("subtotal") or {}
        print(f"Follow-up scorecard validated: {total.get('score')}/{total.get('maximum')} ({total.get('percent')}%).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
