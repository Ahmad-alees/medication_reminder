# AGENTS.md — Medication Reminder (working name: Thakirny, final name TBD)

> Standing instructions for every AI agent in this repository. Read fully before any task.
> This is the single source of truth for rules. Step-by-step playbooks live in `.agents/skills/`.

## 1. Project summary
- **Goal:** help one person stop forgetting medication dose times, reliably and offline, and track adherence.
- **Users:** a **Patient**, or a **Caregiver** managing medication for one person. One Account = one person's medications.
- **Problem:** people with several medications forget dose times; there is no easy record of what was taken or missed.
- **Nature:** personal portfolio project. Reminder-only app. **It never gives medical advice, diagnosis, drug-interaction info, or dosage recommendations.**

## 2. Tech stack and platform
- **Framework:** Flutter (Dart). **Platform: Android only** (do not add iOS/web/desktop code or dependencies).
- **Architecture:** offline-first. The Local Store is the source of truth; nothing blocks on network.
- **Local storage:** on-device DB, `drift` or `sqflite` (**undecided — ask before using**).
- **Reminders:** Local Notifications + alarm-clock-style sound. No server needed for a reminder to fire.
- **Backend (optional, later):** Firebase or Supabase, only for opt-in anonymous Usage Statistics (**undecided — ask**).
- **Localization:** Arabic (RTL) + English via ARB files. No hard-coded user-facing strings.
- **No external drug database.** Medications are entered manually.
- **Plugins / MCP / subagents / hooks:** none yet.

## 3. Non-negotiable rules
1. **A missed reminder is the worst bug.** Reliability outranks features and polish. Any change touching scheduling, notifications, alarms, boot/reboot, battery optimization, or time zones must be flagged in your summary and come with a real-device test plan.
2. **No medical advice** in code, UI, or comments. Escalation Warning wording stays generic (e.g. "Missing or delaying doses may affect your treatment — follow your doctor's instructions").
3. **Local data first.** Never block a user action on network availability.
4. **Ask before adding a dependency** (package, why, alternative) — including notification/alarm/permission packages.
5. **Never edit `Status:` lines** in `intent/`, `specs/`, `plans/`. Only the human changes `draft` → `approved`.
6. **No secrets in the repo.** Use git-ignored env files; keep `*.example` with placeholders only.
7. **Never claim something works without running it.** Alarms are never "working" from emulator-only or unit-test-only evidence.
8. **Never log or upload medication names, Strength, notes, or any health text.**

## 4. Scope reference (core features)
- Add a Medication manually: name, Strength, Reminder Time, Active Days (extra fields only via the intent process).
- Alarm repeats until **Taken** or stopped; **Snooze** available.
- No response after repeated reminders → one Escalation Warning (generic wording), then Missed after cutoff.
- Three-dot menu on a Reminder: edit time, delete (soft delete: history is kept).
- Stock tracking per Medication.
- Adherence Log and Adherence Reports (taken / snoozed / missed).

## 5. Open decisions (do not assume — ask)
- Time-zone behavior when the user travels or the device zone changes.
- Local DB: `drift` vs `sqflite`.
- Backend (Firebase vs Supabase) and what exactly is uploaded.
- Final list of extra Medication fields.
- Low-stock threshold and what happens at the threshold.
- Number of repeats before an Escalation Warning.
- Whether the internal state "ringing" is a documented Dose Status (the glossary defines only Pending / Taken / Snoozed / Missed). "Skipped" is not defined — do not add it.

## 6. Workflow (AI SDLC) — do not skip stages
`Intent → Spec → Plan → Implement → Test → Review`
1. **Intent** — `intent/<slug>.md` via skill `intent-interview`.
2. **Spec** — `specs/<slug>.md` (Gherkin) via `spec-writer`, only from an *approved* intent.
3. **Plan** — `plans/<slug>.md` via `plan-writer`; wait for approval.
4. **Implement** — small steps, one concern at a time, on a branch.
5. **Test** — run tests, fix failures, report honestly (`write-tests`, `debug-reminders`).
6. **Review** — `review-checklist`; summarize diff, risks, unverified items.

No approved intent/spec → propose the intent interview instead of writing code.
For multi-milestone work (M0–M6 in `docs/App_Analysis_AR.md`): stop at each milestone and ask for confirmation.

## 7. Autonomy levels (default L2)
| Level | Use for | Behavior |
|---|---|---|
| L1 Suggest | snippets, explanations | show in chat, touch no files |
| L2 Propose diff | single/small multi-file changes | show diff, wait for approval before writing |
| L3 Execute on branch | features, refactors, end-to-end debugging, reminder-engine changes | plan → approve → edit → test → report |

## 8. Hard rules
**Always**
- Work on a branch (`feat/<slug>`, `fix/<slug>`, `docs/<slug>`, `chore/<slug>`); small focused commits; never push to `main`.
- Match existing conventions; search for an existing helper before writing a new one.
- Parameterized queries only; validate input; render user text safely (very long, mixed Arabic/Latin).
- Add/update tests with every behavior change; a regression test for every bug fix.
- Verify every import/package/API exists in `pubspec.lock` versions.
- Keep scheduling and adherence logic as pure Dart, separate from UI and plugins.
- Every user-visible string goes in the ARB files (Arabic + English).
- Use the exact terms in `docs/glossary.md`.

**Ask first**
- New dependency · DB schema or migration change · `AndroidManifest.xml`, permissions, Gradle, minSdk/targetSdk.
- Any change to reminder-engine behavior (scheduling, escalation, reschedule triggers).
- Anything uploaded off-device (sync payload, remote rules).
- Deleting files or large renames · any task touching more than ~5 files.

**Never**
- Push to protected branches, force-push, rewrite shared history.
- Commit secrets, tokens, real user data, key files.
- Paste real health data into external tools or prompts.
- Build SQL by string concatenation.
- Disable, skip, or weaken a test to make it pass.
- Invent APIs, flags, permissions, or package functions.
- Add medical advice, drug-interaction info, or dosage recommendations.

## 9. Repository layout
```
AGENTS.md  CLAUDE.md  README.md
.agents/skills/   intent-interview, spec-writer, plan-writer, review-checklist,
                  reminder-engine, debug-reminders, write-tests
docs/             PRD.md  glossary.md  AI_LOG.md  DEMO_SCRIPT.md  App_Analysis_AR.md
intent/ specs/ plans/   _template.md + one file per feature
design/           exported screens / Stitch links
lib/core/         constants, time utils, errors, l10n helpers
lib/data/         local DB, repositories, (later) sync source
lib/domain/       models + pure rules: dose generation, dose state machine, adherence calc
lib/scheduling/   reminder engine: schedule / reschedule / escalation / permission health check
lib/features/     today, medications, add_edit, alarm, history, reports, settings, onboarding
android/          manifest, permissions, boot receiver
test/             unit (domain, scheduling) > widget > integration
```
Update this block whenever the structure changes.

## 10. Commands
```
flutter pub get
flutter run                          # verify alarms on a real Android device
flutter test                         # all tests
flutter test test/<path>_test.dart   # single file
dart format . && flutter analyze     # zero warnings
```

## 11. Project-specific rules
- **Reminder model:** a Reminder stores the **local wall-clock time** (`"08:00"`) plus Active Days. A Dose event stores `scheduled_at_utc` and `utc_offset_minutes`. Adherence stats come from stored events, never recomputed from the current time zone.
- **Reschedule triggers:** device reboot, time-zone change, system-time change, app update, app open, any Reminder edit/delete. Missing one is a bug.
- **Rolling window:** schedule only the next N days of alarms (default 7) and refill; never schedule indefinitely.
- **Dose state machine:** `pending → ringing ⇄ snoozed → taken | missed`. Terminal states are final except an explicit manual correction from History. **Taken must be idempotent.**
- **Defaults (assumptions, confirm):** snooze 10 min, repeat every 5 min, Escalation Warning after 3 unanswered repeats, Missed after 60 min. Named, configurable constants — never inline numbers.
- **Escalation Warning** is sent once per Dose, not on every repeat.
- **Permissions:** the app must keep working (with a persistent visible warning) when permissions are denied; it must never fail silently. Verify exact-alarm, notification, full-screen-intent, and boot permissions against current Android docs before implementing.
- **Soft delete:** deleting a Medication stops future alarms but keeps its history.
- **Disclaimer:** reminder-only; shown in onboarding and Settings. No medical content anywhere.
- **Language:** product analysis in Arabic (`docs/App_Analysis_AR.md`); code, identifiers, and technical docs in English.
- **Optional anonymous stats sync (not MVP):** off by default; explicit consent; can be disabled and uploaded data deleted; payload = anonymous random id + Dose Status + scheduled/acted timestamps (UTC + offset), **never** medicine names, Strength, notes, or free text. Local queue with retry, never blocks UI or reminders. Remote rules allow an anonymous client to insert only its own events. If an AI feature is ever added, call the provider from a server only — never ship an API key in the app.
- Every time you correct the agent twice for the same mistake, add a rule here.

## 12. Commits, PRs, AI log
- **Commits:** Conventional Commits `type(scope): imperative summary` (<72 chars): feat, fix, docs, test, refactor, chore.
- **PR description:** What / Why / How it was verified (commands + real-device checks) / Not verified & risks / Security & privacy checklist done (yes/no) / AI assistance (what was AI-drafted, what I changed).
- **Docs:** any behavior change updates README/docs in the same PR.
- **AI log:** record meaningful prompts, decisions, and suggestions I rejected or changed (with why) in `docs/AI_LOG.md`.

## 13. Communication
- Reply in **Arabic** by default (code, identifiers, commits, file names in English), unless I write in English.
- Structure substantial answers: **Objective → Approach → Implementation → Verification → Next steps**; ask confirmation before the next milestone.
- After each task state: what changed, what was tested (and how), what could **not** be verified, any risk to reminder reliability.
- Concise Markdown, no filler. If unsure or blocked, stop and say so.
- Context hygiene: read only relevant files; summarize decisions when a session gets long; record stable decisions here, not in chat.
