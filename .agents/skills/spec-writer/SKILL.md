---
name: spec-writer
description: Turns an APPROVED intent file into specs/<slug>.md with Gherkin acceptance criteria for the Medication Reminder app. Use after the author sets an intent to Status approved.
---

# Spec writer

## Preconditions
- Read `intent/<slug>.md`. If its last line is not `Status: approved`, stop and ask the author to approve it.
- Read `AGENTS.md`, `docs/glossary.md`, `specs/_template.md`.

## Steps
1. Copy `specs/_template.md` to `specs/<slug>.md` (same slug as the intent).
2. For each scenario and each "when things go wrong" item in the intent, write a Gherkin scenario.
3. Go through the edge-case checklist (reboot, time-zone/DST/manual clock change, 23:59/00:00, two Doses same minute, double-tap Taken, edit/delete while ringing, permissions denied, battery saver, Arabic/Latin long names). Add a scenario only where it applies, and list it under "Derived edge cases" so the author can confirm.
4. Use glossary terms exactly (Dose vs Strength, Alarm vs Escalation Warning). No implementation details in Gherkin. Never use "skipped".
5. Escalation wording must stay generic; no medical content in any scenario.
6. Unclear points go under Open questions. End with `Status: draft`.

## Rules
- Do not invent requirements. Never set `Status: approved`.
- Do not write code or a plan. Next step: the author reviews and approves the spec.
