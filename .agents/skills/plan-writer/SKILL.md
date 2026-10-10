---
name: plan-writer
description: Turns an APPROVED spec into plans/<slug>.md, a short ordered implementation plan for the Medication Reminder app. Use after the author approves a spec and before any code is written.
---

# Plan writer

## Preconditions
- `specs/<slug>.md` must end with `Status: approved`; otherwise stop and ask.
- Read `AGENTS.md` ("Ask first", §3, §11) and `plans/_template.md`.

## Steps
1. Inspect the existing code first (`lib/domain`, `lib/scheduling`, tests); reuse existing utilities.
2. Copy the template to `plans/<slug>.md`.
3. Write small ordered steps. Prefer this order: pure domain logic + tests (fake clock) → persistence → plugin wrapper behind an interface → reschedule triggers → UI → escalation.
4. Map every Gherkin scenario to at least one unit/widget test or a manual real-device check.
5. List what needs prior approval: dependency, DB schema, manifest/permissions, reminder-engine behavior, uploaded data.
6. State risks to reminder reliability and the real-device matrix to run.
7. End with `Status: draft`.

## Rules
- No code in this stage. Wait for the author's approval before implementing.
- Plans touching more than ~5 files or the reminder engine run at L3 on a branch.
