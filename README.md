# Medication Reminder (Thakirny)

> **ذاكرني: تطبيق أندرويد يذكّرك بمواعيد أدويتك ويعمل بدون إنترنت، ويسجّل التزامك بها.**
> تطبيق للتذكير فقط، ولا يقدّم أي نصيحة طبية. يدعم العربية (RTL) والإنجليزية.

An Android app, built with Flutter, that reminds a person to take their medication on time, works fully
offline, and keeps a record of what was taken and what was missed.

**It is a reminder tool only. It never gives medical advice, diagnosis, drug-interaction information, or
dosage recommendations.**

> **Status:** early development. The project structure, agent rules, and glossary are in place; the app
> itself is still the default Flutter template. Everything under "Features" is planned, not built yet.
> The working name "Thakirny" is not final.

---

## The problem

People who take several medications often forget dose times, and there is no easy record of what was
actually taken or missed. A forgotten dose is the failure this app exists to prevent.

## Who it is for

- **Patient:** the person who takes the medications.
- **Caregiver:** a family member or nurse who manages one person's medications in the app.

One account holds the medications of exactly one person. A caregiver managing two people uses two accounts.

## Features (planned)

- **Add a medication** manually: name, strength, reminder time, and the days of the week.
- **Alarm-style reminders** that keep repeating until you tap **Taken** or stop them, with **Snooze**.
- **Follow-up warning** if you do not respond after repeated reminders (generic wording only, never medical advice).
- **Edit or delete** a reminder from a three-dot menu. Deleting keeps the history.
- **Stock tracking** per medication.
- **Adherence log and reports:** taken, snoozed, and missed doses over time.
- **Arabic and English** interface, including right-to-left layout.
- **Optional, opt-in anonymous usage statistics** (later, not part of the first release).

## What this app is not

- Not a medical app: no advice, diagnosis, dosage recommendations, or drug-interaction information.
- No external drug database. Medication details are entered by the user.
- Not iOS or web. Android only.
- Not dependent on the internet or an account. Everything works offline.

## Design principles

1. **Reminder reliability comes first.** A missed reminder is the worst bug. Reliability outranks features and polish.
2. **Offline-first.** The on-device database is the source of truth. Nothing blocks on the network.
3. **Privacy by default.** Medication names, strengths, and notes are never logged or uploaded.
4. **Fail loudly.** If a permission is denied, the app keeps working and shows a persistent warning instead of failing silently.

## Tech stack

| Area | Choice |
|---|---|
| Framework | Flutter (Dart) |
| Platform | Android only |
| Local storage | On-device database (`drift` or `sqflite`, not decided yet) |
| Reminders | Local notifications and alarm-style sound, no server required |
| Backend | None in the first release (Firebase or Supabase may be used later for opt-in anonymous stats, undecided) |
| Localization | Arabic and English via ARB files |

## Getting started

```bash
flutter pub get
flutter run                        # use a real Android device to check alarms
flutter test
dart format . && flutter analyze
```

> Alarm and notification behavior must be verified on a **real Android device**, not only on an emulator.
> Some manufacturers restrict background alarms through battery optimization.

## Permissions

The app is expected to need exact alarms, notifications, full-screen intent, and run-on-boot. These will be
confirmed against current Android documentation before implementation. If any is denied, the app shows a
persistent warning.

## Project structure

```
AGENTS.md                 standing rules for AI agents (single source of truth)
CLAUDE.md                 points to AGENTS.md
.agents/skills/           reusable agent playbooks
docs/
  PRD.md                  product requirements
  glossary.md             project vocabulary
  AI_LOG.md               AI prompts, decisions, rejected suggestions
  DEMO_SCRIPT.md          demo outline
intent/                   one file per feature: what the author wants, in their own words
specs/                    acceptance criteria (Gherkin) from approved intents
plans/                    implementation plans from approved specs
design/                   exported screens and design links
lib/                      Flutter source (core, data, domain, scheduling, features)
test/                     unit, widget, and integration tests
android/                  manifest, permissions, boot receiver
```

## How features are built

This project is developed with AI assistance, in reviewed steps:

`Intent → Spec → Plan → Implement → Test → Review`

- A feature starts as an **intent** file written from the author's own answers.
- Only the author moves an intent or spec from `draft` to `approved`.
- No code is written without an approved spec and plan.
- Every change ships with tests, and alarm behavior is checked on real devices.
- Meaningful AI decisions, including rejected suggestions, are recorded in `docs/AI_LOG.md`.

See `AGENTS.md` for the full rules and `docs/glossary.md` for the exact terms used in code, tests, and UI text.

## Disclaimer

This app only reminds you to take medication you have already been prescribed. It does not replace a
doctor or pharmacist. Always follow your doctor's instructions.