---
name: mindai-dev-workflow
description: Structured AI-assisted development workflows (MIND AI "Coding with AI" curriculum) adapted for the Flutter/Android Medication Reminder app. Use when shaping a vague request into a prompt, turning an idea into requirements and tasks, generating or refactoring Dart/Flutter code, debugging (especially alarms, notifications, time handling), writing tests, producing docs/commit/PR text, building the reminder engine or the optional stats sync, reviewing code for security/privacy, or preparing the portfolio case study. Do not use for trivial one-line edits.
---

# mindai-dev-workflow

Standing rules live in `Agent.md`. Product requirements live in `docs/App_Analysis_AR.md`. This skill holds the step-by-step playbooks and copy-paste templates.
Pick the workflow that matches the task. Each one ends with a **Verify** step that is never skipped.

| # | Workflow | Trigger phrases |
|---|---|---|
| 1 | Choose the AI level | "what's the best way to do this", starting any task |
| 2 | Prompt shaping | vague request, "improve X", "make it better" |
| 3 | Requirements & decomposition | new feature, epic, "plan", "scope" |
| 4 | Generate & refactor | "build", "add", "refactor", "convert" |
| 5 | Debug | error, stack trace, "reminder didn't fire", wrong result |
| 6 | Test generation | "add tests", coverage, regression |
| 7 | Docs & git | README, docs, commit, PR, changelog |
| 8 | Reminder engine & optional sync | alarm, notification, reschedule, escalation, upload stats |
| 9 | Security & privacy review | before merge, permissions, logging, uploads, dependencies |
| 10 | Portfolio case study | scope, log, demo, presentation |

---

## 1. Choose the AI level

| Task size | Use | Autonomy (see Agent.md §2) |
|---|---|---|
| Boilerplate, small widget/function | Inline suggestion / chat | L1 |
| Explain unfamiliar code, plugin, or Android permission | Chat | L1 |
| Change in 1–3 files | Agent proposes a diff | L2 |
| Feature, refactor, end-to-end debug, reminder-engine change | Agent on a branch with tests | L3 |

**Example (add a "dose amount" field to the medicine form):** agent locates the form widget, the model, the DB table, and their tests, then proposes a minimal diff. Chat explains one unfamiliar Drift/sqflite migration concept. **Verify:** read every changed file, run the related tests, confirm the schema change was approved first (Agent.md "Ask first").

---

## 2. Prompt shaping

Turn every vague request into four parts before any code is written.

```
CONTEXT:     <files, Flutter/Dart + plugin versions, related code, earlier decisions>
TASK:        <one precise goal>
CONSTRAINTS: <style, allowed/disallowed packages, Android version, keep current API/UI>
FORMAT:      <diff only | full file | signature | include tests>
```

**Techniques, used when useful:**
- **Few-shot:** paste 1–2 input/output examples of the pattern wanted.
- **Chain-of-thought:** "List your assumptions and plan step by step before writing code."
- **Role:** "Act as a senior Flutter/Android developer reviewing for reliability and maintainability."
- **Iterative refinement:** critique the draft ("missing the midnight case, make the change smaller") instead of restarting.

**Before → after**
- Before: *"Make the reminders more reliable."*
- After: *"In `lib/scheduling/`, reschedule all upcoming doses after device reboot using the existing boot receiver. Keep the current dose model and notification channel. Add unit tests for the reschedule logic with a fake clock. Show the proposed diff only, and list any Android permission you are assuming."*

**Verify:** prompt names the right file and behavior, and states what "success" means.

---

## 3. Requirements & decomposition

Order: **Epic → User stories → Tasks → Architecture.** Do not write code until stories and acceptance criteria are agreed. The current stories (US-01…US-10) are in `docs/App_Analysis_AR.md`; extend them rather than duplicating.

**Templates**
```
USER STORY: As a <user>, I want <goal>, so that <benefit>.

ACCEPTANCE CRITERIA (testable):
- Given <state>, when <action>, then <result>.
- ...

USE CASE: main flow, alternate flows, failure paths.

TASKS: UI / Domain logic / Data / Scheduling / Tests / Docs, each estimable, each with dependencies.
```

**Checklist AI tends to miss, always ask about:** time zones and DST, device reboot, battery optimization / Doze, denied permissions, two doses at the same minute, editing or deleting a dose while it is ringing, cancellation/undo (can a "taken" be corrected?), empty/error states, RTL layout, data migration, dependencies between tasks.

**Example (US-04 escalation):** repeat the alarm every N minutes while unanswered; after K repeats send one warning notification; after the missed cutoff mark the dose missed and stop.

**Procedure**
1. Draft stories + criteria from the idea.
2. List assumptions separately and mark each "needs owner confirmation" (see §13 of the analysis doc).
3. Decompose into tasks; propose architecture; wait for approval.

**Verify:** every acceptance criterion maps to at least one test or manual real-device check.

---

## 4. Generate & refactor

### Generate
1. Restate the task and acceptance criteria.
2. Search the repo for an existing utility/pattern first.
3. Generate the smallest useful unit (pure function, repository method, widget), in the project's style.
4. Generate focused tests in the same step.
5. Run `dart format . && flutter analyze` and `flutter test`.

Good fits: scaffolding, models and DB tables from the data model, pure algorithms from a stated rule (next-dose calculation, adherence %), ARB localization entries. Keep scope narrow enough to understand.

**Example:** `List<DoseEvent> generateDoses(Schedule s, DateTime fromLocal, int days, TimeZoneInfo tz)`. Specify outputs for: every day, selected weekdays, end date reached, DST day, 23:59/00:00. Ask for tests plus stated assumptions; check it does not duplicate an existing date helper.

### Refactor
Allowed goals: clearer names, extract repeated logic, flatten nested conditionals, move logic out of widgets into `domain/`, remove redundant queries, reduce coupling to plugins.
Rules: **no behavior change**, tests green before and after, one kind of refactor per commit.

### Review gate (always)
Run Agent.md §6 checklist on the diff. Ask the agent to list anything it is unsure exists (packages, plugin APIs, Android permissions).

---

## 5. Debug

**Flow:** Reproduce → Isolate → Ask with context → Verify the fix.

**Debug prompt template**
```
EXPECTED:   <what should happen>
OBSERVED:   <what happens, exact error / stack trace / logcat excerpt (no medicine names)>
REPRO:      <minimal steps or input; device model + Android version>
CODE:       <smallest relevant snippet or file path>
ENV:        <Flutter/Dart version, plugin versions, battery-saver / permission state>
ASK:        List the most likely causes, ranked, and how to confirm each.
            Write a failing regression test FIRST where possible. Do not change code yet.
```

**Rules**
- Hypothesis first, fix second. Confirm the cause with evidence.
- Never "fix" by suppressing errors, loosening assertions, or deleting tests.
- Fix → regression test passes → related suite passes → re-check on a real device if it is an alarm/notification issue.

**Example (boundary bug):** a dose at 23:59 appears under the next day in the report. Check whether the date is derived from UTC instead of the stored local date/offset; test 23:59, 00:00, 00:01 and a DST-change day.

**Example (alarm bug):** reminders stop firing after reboot. Hypotheses: boot receiver missing/not registered, reschedule not triggered, permission revoked, OEM battery restriction. Confirm each with logs before changing code.

---

## 6. Test generation

Request, in this order: **unit tests → edge cases → regression test → test data.**

**Test prompt template**
```
Write tests for <function/module> using flutter_test (and the mocking approach already in the project).
Cover: happy path, boundary values, empty/null, invalid input, special characters / mixed Arabic-Latin text,
failure paths. Use an injectable fake clock/timezone, never the real device time.
Follow the style of <existing test file>. List any behavior you had to assume.
```

**Shape:** many unit tests (domain, scheduling logic, adherence calc), fewer widget tests (forms, alarm screen buttons, RTL), fewest integration tests. Alarm delivery itself is checked **manually on real devices** (Agent.md §8).

**Verify:** tests fail when the code is wrong (temporarily break the logic and confirm), and pass when it is right. Tests that cannot fail are worthless.

---

## 7. Docs & git

**Generate from a reviewed diff, then verify every claim against code and tests.** Ask the AI to flag facts it cannot confirm.

| Artifact | Contents |
|---|---|
| README update | setup, run on a real device, permissions the app needs, known OEM limitations |
| Docs entry | behavior of reminder engine, defaults (snooze/repeat/missed), data model changes |
| Code comments | the *why*, not the *what* (especially time-handling decisions) |
| Changelog entry | user-visible changes, grouped |

**Commit message**
```
type(scope): imperative summary (<72 chars)

Why the change was needed. Notable trade-offs.
```

**PR template**
```
## What
## Why
## How it was verified   (commands run + results; real-device checks done)
## Not verified / risks
## Security & privacy checklist   (Agent.md §7 done: yes/no)
## AI assistance          (what was AI-drafted, what I changed)
```

**Verify:** follow the README from a clean setup; delete any behavior claim the code does not support. Never let the agent push to a protected branch.

---

## 8. Reminder engine & optional sync

### 8A. Reminder engine (core of the app)

Blueprint:

```
Schedule (local "HH:mm" + weekdays)
   │  generate doses for next N days (pure function)
   ▼
DoseEvent rows (local date/time + UTC + offset)
   │  schedule exact alarms (plugin layer, thin wrapper)
   ▼
Alarm fires → alarm screen / notification (sound, full-screen)
   │  Taken | Snooze | no response
   ▼
State machine: pending → ringing ⇄ snoozed → taken | missed
   │  repeat every N min → warning once after K repeats → missed after cutoff
   ▼
Log + stock update + adherence stats
```

**Build order**
1. Pure domain: dose generation + state machine + adherence calc, with tests (fake clock).
2. Persistence: dose events, settings, idempotent updates.
3. Plugin wrapper: schedule/cancel/replace alarms behind an interface (so logic can be tested with a fake).
4. Reschedule triggers: boot, timezone/time change, app update, app open, schedule edit/delete.
5. Alarm UI + Taken/Snooze actions (also from the notification itself).
6. Escalation + missed cutoff.
7. Permission/health check screen and persistent warning banner.

**Test matrix:** reboot, kill app, battery saver, DST change, timezone change, manual clock change, two doses same minute, double-tap Taken, edit/delete while ringing, permission denied, 23:59/00:00, snooze across midnight.

**Verify:** run the real-device matrix and record results; confirm no stale alarm fires after an edit/delete.

### 8B. Optional anonymous stats sync (not MVP)

```
App (local DB) --opt-in--> local queue --online--> Firebase/Supabase
        payload: anonymous id + dose status + timestamps. NO medicine names/notes.
```

1. Define the payload schema and what is explicitly excluded.
2. Consent screen + settings toggle (default off) + delete-my-data.
3. Local queue with retry; never blocks UI or reminders.
4. Remote rules: anonymous client may insert only its own events.
5. Logging: counts and errors only; no health text.

**Test matrix:** consent off → nothing sent; offline queueing; retry; duplicate send; malformed/oversized payload; delete-my-data.

**Verify:** inspect the actual outgoing payload; search repo and git history for keys/config; confirm key/config files are git-ignored.

---

## 9. Security & privacy review

Run before every merge of AI-written code. Answer each with evidence (file + line), not "looks fine".

1. **Injection:** any SQL built by string concatenation? → use the DB library's parameterized API.
2. **Rendering:** any user text (medicine name, notes) rendered unsafely or breaking layout (very long, RTL/LTR mixed)?
3. **Secrets:** search diff + history for keys, tokens, passwords, config files.
4. **Health-data privacy:** do logs, analytics, crash reports, notifications on a locked screen, or uploads expose medicine names or other health text? (Consider whether lock-screen notification content should be hideable.)
5. **Permissions:** each Android permission is necessary, minimal, justified to the user, and the app degrades gracefully if denied.
6. **Dependencies:** each new package exists, is maintained, and is truly needed (check for typo-squats and hallucinated names; check `pubspec.lock`).
7. **Remote access (if sync exists):** Firebase Rules / Supabase RLS reviewed; anonymous clients can only insert their own events.
8. **Input limits:** size limits and type checks on medicine fields and any uploaded payload.

**Procedure**
1. Ask AI to identify the trust boundaries (device storage, notifications, network) and explain the risk line by line.
2. Request a safe alternative that fits the current setup.
3. Inspect the final code yourself.
4. Add tests for long/odd text and for "nothing sent when consent is off"; run the full suite.

**Responsible use:** follow organization policy on AI-assisted code; do not paste real personal health data into prompts; review third-party snippets like any other code; you remain accountable for what ships.

---

## 10. Portfolio case study

**Scope:** one user problem (forgetting dose times), the acceptance criteria in `docs/App_Analysis_AR.md`, and a small first release (M0–M4).

**Build & record:** plan → implement → test → document, in reviewed steps. Keep `docs/AI_LOG.md`.

**Deliverables:** working APK/demo on a real device, README with clean setup steps, basic tests, privacy/quality self-review (use §9 and Agent.md §6–§9), design files from Stitch/Figma, and a short case study.

**Demo script (5–8 min)**
1. The problem and who it's for (1 min)
2. Live walkthrough: add a medicine, the alarm fires with the phone locked, Taken/Snooze, escalation, then the report
3. Show tests running, and the README setup
4. **One AI suggestion I changed** and why
5. **One trade-off** I made (e.g. exact-alarm reliability vs battery, or offline-first vs cloud stats)
6. How I checked privacy and reliability (real-device matrix)
7. What I would do next

**`docs/AI_LOG.md` template**
```markdown
# AI Log

## <YYYY-MM-DD> — <short task title>
- Goal:
- Prompt (summary):
- AI output (summary):
- Decision: accepted | changed | rejected
- Why:
- Verification done: (tests run; real-device checks: device + Android version)
```

---

## Always-on reminders

- Smallest change that works; approve the plan before L3 execution.
- No invented APIs, packages, or permissions. If unsure, say so and check the docs.
- Nothing is "done" until it has been run and the result reported; alarms need a real device.
- Ask before adding dependencies, changing schema, manifest/permissions, or the reminder engine.
- Never log or upload medicine names or health text.
