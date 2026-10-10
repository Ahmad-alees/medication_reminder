# AGENTS.md — Medication Reminder App

> Standing instructions for every AI agent working in this repository.
> Read this file fully before starting any task.

## 1. Project summary

A mobile app that reminds people to take their medication on time and tracks
whether they actually took it (adherence).

- **Users:** a patient, or a caregiver managing medication for one person.
  One account = one person's medications.
- **Problem solved:** people with several medications forget dose times; there
  is no easy record of what was taken or missed.
- **Nature:** personal portfolio project. Reminder-only app.
  **It never gives medical advice, diagnosis, or dosage recommendations.**

## 2. Tech stack and platform

- **Framework:** Flutter (Dart)
- **Platform:** Android only (do not add iOS/web code or dependencies)
- **Architecture:** offline-first. The app must be fully usable with no internet.
- **Local storage:** on-device database is the source of truth.
- **Reminders:** local notifications plus an alarm-clock-style sound.
  No server is needed for a reminder to fire.
- **Backend (optional, later):** Firebase or Supabase, used only to upload
  usage statistics after local data is saved. Not decided yet — do not pick
  one without asking.
- **Languages:** Arabic and English UI, including RTL layout. No hard-coded
  user-facing strings; use localization files.
- **No external drug database.** Medication data is entered manually.

## 3. Non-negotiable rules

1. **Reminder reliability is the top priority.** A missed reminder is a
   critical bug. Any change touching scheduling, notifications, alarms,
   boot/reboot handling, battery optimization, or time zones must be flagged
   in your summary and come with a test plan on a real device.
2. **Never write medical advice** in code, UI text, or comments. Warning text
   about missed doses must stay generic (e.g. "Missing or delaying doses may
   affect your treatment — follow your doctor's instructions").
3. **Local data first.** Never block a user action on network availability.
4. **Ask before adding a dependency.** State the package, why it is needed,
   and the alternative.
5. **Do not touch** `intent/*.md` status lines. Only the human changes a
   file from `draft` to `approved`.
6. **No secrets in the repo** (API keys, Firebase/Supabase config with keys).
   Use environment files that are git-ignored.

## 4. Core features (scope reference)

- Add a medication manually: name, strength, reminder time, days of the week
  (additional fields may be proposed through the intent process).
- Reminder repeats until the user taps **Taken** or stops it; **Snooze**
  is available.
- If the user does not respond after repeated reminders, show a follow-up
  notification with the generic warning from rule 2.
- Three-dot menu on a reminder: edit time, delete.
- Stock/inventory tracking per medication.
- Adherence log and reports (taken / snoozed / missed).

## 5. Open decisions (do not assume — ask)

- Time-zone handling when the user travels or the device zone changes.
- Backend choice (Firebase vs Supabase) and what exactly is uploaded.
- Final list of extra medication fields.

## 6. Workflow (AI SDLC)

Work moves through these stages in order. Do not skip ahead.

1. **Intent** — `intent/<slug>.md`, produced by the `intent-interview` skill.
2. **Spec** — acceptance criteria in Gherkin, derived only from an
   *approved* intent.
3. **Plan** — a short implementation plan; wait for human approval.
4. **Implement** — small steps, one concern at a time.
5. **Test** — run tests, fix failures, report results honestly.
6. **Review** — summarize the diff, risks, and anything unverified.

If a request arrives with no approved intent/spec, propose running the
intent interview instead of writing code.

## 7. Repository layout

```
AGENTS.md                 this file
docs/
  glossary.md             project vocabulary (single source of truth)
  PRD.md                  product requirements
intent/
  _template.md            template for intent files
  <slug>.md               one file per feature/change
design/                   exported screens / links from Stitch
.agents/skills/           agent skills (e.g. intent-interview)
lib/                      Flutter source
test/                     tests
```

## 8. Code conventions

- Follow `flutter analyze` and the project's lint rules; zero warnings.
- Separate UI, state management, and data layers; no business logic in widgets.
- Name things using the terms in `docs/glossary.md`.
- Keep functions small; comment *why*, not *what*.
- Every new feature ships with tests, especially scheduling logic.

## 9. Commands

```
flutter pub get
flutter analyze
flutter test
flutter run            # run on a connected Android device/emulator
```

(Update this section when the project's real commands change.)

## 10. How to report back

After each task, state: what changed, what you tested (and how), what you
could **not** verify, and any risk to reminder reliability.
Never claim a test passed unless you ran it.