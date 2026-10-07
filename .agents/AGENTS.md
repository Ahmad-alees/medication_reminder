# Agent.md — Standing Instructions for the AI Agent

> Read automatically at the start of every session. Keep it short, current, and specific.
> Based on the MIND AI Labs "Coding with AI" curriculum (Modules 1–9), adapted for the Medication Reminder app.
> Tool note: Claude Code reads `CLAUDE.md`; Cursor/Codex/others read `AGENTS.md` or `.cursorrules`.
> Keep ONE source of truth: put `@Agent.md` inside `CLAUDE.md` and `AGENTS.md`, or symlink them.
> Full product analysis (Arabic): `docs/App_Analysis_AR.md`. It is the source for requirements; this file holds the rules.

---

## 0. Project Profile  (fill once, keep updated)

| Field | Value |
|---|---|
| Project name | `Medication Reminder` (final name TBD) |
| One-line goal | Help one person stop forgetting medication dose times, reliably, offline, and track adherence. |
| Platform | Android only |
| Language / framework | Dart + Flutter |
| Database | Local on-device DB (`drift` or `sqflite` — **not yet decided; confirm before use**) |
| Backend | None in MVP. Optional later: Firebase or Supabase for anonymous adherence stats (**undecided**) |
| Install | `flutter pub get` |
| Run (dev) | `flutter run` (alarm behavior must be verified on a real Android device, not only the emulator) |
| Test (all) | `flutter test` |
| Test (single file) | `flutter test test/<path>_test.dart` |
| Lint / format | `dart format . && flutter analyze` |
| Main branch (protected) | `main` |
| Working-branch naming | `feat/<slug>`, `fix/<slug>`, `docs/<slug>`, `chore/<slug>` |

**If any field above is unconfirmed or a `<placeholder>`:** inspect the repo (`pubspec.yaml`, `analysis_options.yaml`, `android/app/build.gradle*`, `AndroidManifest.xml`, CI config) to infer it, state what you inferred, and ask me to confirm before relying on it. Never guess commands silently.

### Architecture map
```
lib/core/          constants, time utils, errors, l10n helpers
lib/data/          local DB, repositories, (later) sync source
lib/domain/        models + pure business rules: dose generation, dose state machine, adherence calc
lib/scheduling/    reminder engine: schedule / reschedule / escalation / permission health check
lib/features/      today, medications, add_edit, alarm, history, reports, settings, onboarding
android/           manifest, permissions, boot receiver
test/              unit (domain, scheduling logic) > widget > integration
docs/              App_Analysis_AR.md, AI_LOG.md, README notes
```
Update this block whenever structure changes (the above is the planned structure until the repo exists).

---

## 1. Core Principles (non-negotiable)

1. **Plan before you generate.** Requirements and task breakdown come first, code second.
2. **AI proposes, the human decides.** I approve plans, diffs, and merges.
3. **Every line is reviewed, tested, and owned** by me before it ships.
4. **Smallest change that works.** Narrow, reviewable diffs beat big rewrites.
5. **Verify, never assume.** A fix is not a fix until a test or reproduction proves it.
6. **Security and quality are part of the job**, not a final polish step.
7. **Say what you don't know.** Flag unverified facts, assumptions, and APIs, packages, or Android permissions you are not sure exist or behave as expected.
8. **A missed reminder is the worst bug in this app.** Reliability of reminders outranks features and visual polish.

---

## 2. Autonomy Levels

Pick the lowest level that fits the task (Module 1: match the tool to the task).

| Level | Use for | Agent behavior |
|---|---|---|
| **L1 Suggest** | Small snippets, boilerplate, explanations | Show code in chat; do not touch files |
| **L2 Propose diff** | Single-file or small multi-file changes | Show the diff; wait for approval before writing |
| **L3 Execute in a branch** | Features, refactors, end-to-end debugging | Plan → approve → edit → run tests → report, on a working branch |

Default is **L2**. Escalate to L3 only when I say so or the task is clearly multi-step and I have approved the plan.

---

## 3. Task Intake — every request is shaped as

- **Context:** which files, Flutter/Dart and plugin versions, related code, earlier decisions
- **Task:** one precise goal
- **Constraints:** standards, allowed/disallowed packages, Android version support, style
- **Format:** diff only / full file / function signature / tests included

If the request is vague ("make reminders better"), do NOT start coding. Reply with a rewritten, scoped version of the task (files, behavior, edge cases, success criteria) and ask for a yes/no. Ask at most one clarifying question at a time.

---

## 4. Workflow (the loop for every non-trivial task)

1. **Understand** — read the relevant files, tests, and conventions before changing anything.
2. **Plan** — list the steps, files to touch, risks, and how success will be checked. Wait for approval (L3).
3. **Implement** — small commits, matching existing style and utilities (search for an existing helper before writing a new one).
4. **Verify** — run the tests and the linter; reproduce the original scenario; report real output, not assumptions. For anything involving alarms or notifications, state what was tested on a real device and what was not.
5. **Review** — run the checklists in §6 and §7 against your own diff.
6. **Document** — update README/docs/changelog if behavior changed; log the AI decision (see §10).
7. **Report** — summarize what changed, what was verified, what is still uncertain.

For multi-milestone work (M0–M6 in `docs/App_Analysis_AR.md`): stop at each milestone boundary and ask for confirmation before continuing.

---

## 5. Hard Rules

### Always
- Work on a branch; keep commits small and focused.
- Match the project's existing conventions, naming, and folder structure.
- Use parameterized queries (DB layer API, no string-built SQL), validate all input, escape rendered text.
- Keep secrets/keys in environment/config files that are git-ignored; keep `*.example` files with placeholder values only.
- Add or update tests with every behavior change, including a regression test for every bug fix.
- Check that every import, package, and function you use actually exists in this project's dependency versions (`pubspec.lock`).
- Keep scheduling and adherence logic as pure Dart functions, separate from UI and plugins, so they are unit-testable.
- Put every user-visible string in the localization files (Arabic + English). No hardcoded UI text.

### Ask first
- Adding a new dependency (justify: real, maintained, actually necessary). This includes notification/alarm/permission packages.
- Changing the database schema or migrations.
- Changing `AndroidManifest.xml`, permissions, Gradle config, or minSdk/targetSdk.
- Changing the reminder engine's behavior (scheduling, escalation, reschedule triggers).
- Changing anything that is uploaded off-device (sync payload, remote rules).
- Deleting files or large-scale renames.
- Any task that touches more than ~5 files.

### Never
- Push to `main` or any protected branch, force-push, or rewrite shared history.
- Commit secrets, tokens, real user data, or key files.
- Paste proprietary code or real user health data into external tools or prompts.
- Build SQL by string concatenation.
- Disable, skip, or weaken a test to make it pass.
- Invent APIs, flags, permissions, or package functions. If unsure, say so and check the docs or the source.
- Claim something works without having run it. Never claim alarms "work" from emulator-only or unit-test-only evidence.
- Log or upload medication names, doses, or any identifying health text (see §11).
- Add medical advice, drug-interaction info, or dosage recommendations. The app is a reminder only.

---

## 6. Review Checklist for AI-Generated Code (Module 4)

- [ ] Does it run, and does it solve the stated task?
- [ ] Are all imports, packages, and functions real (not hallucinated)?
- [ ] Does it follow existing conventions and style?
- [ ] Does it duplicate an existing utility?
- [ ] Obvious security/privacy issues checked (see §7)?
- [ ] Time handling correct (local wall-clock vs UTC, DST, midnight)?
- [ ] Does it work in Arabic (RTL) and English?
- [ ] Could I explain this code to a teammate?

## 7. Security & Privacy Checklist — before anything is merged (Module 8)

- [ ] No raw SQL string concatenation
- [ ] User-entered text (medicine names, notes) rendered safely and handled when very long / mixed-direction
- [ ] No hardcoded keys, passwords, or secrets
- [ ] No medication names, doses, or notes in logs, analytics, crash reports, or uploads
- [ ] Anything uploaded is opt-in, anonymous, and limited to the agreed payload
- [ ] Remote rules (Firebase Rules / Supabase RLS), if any, allow only what is needed (e.g. insert-only for anonymous id)
- [ ] New dependencies are real, maintained, and necessary
- [ ] Android permissions requested are the minimum needed and each has a user-facing explanation

---

## 8. Testing Standards (Module 5)

- Follow the **testing pyramid**: many unit tests, fewer widget tests, fewest integration tests; plus manual real-device checks for alarms.
- **Boundary values** for every rule with a threshold: dose exactly at the "missed" cutoff, 59/60/61 minutes; snooze count limits; stock 0 / 1 / threshold.
- **Edge cases** to always consider: 23:59 and 00:00 doses, DST change, timezone change, manual clock change, device reboot, two doses at the same minute, double-tap on "Taken", editing/deleting a dose while it is ringing, empty/very long/mixed Arabic-Latin medicine names, permissions denied.
- **Bug workflow:** Reproduce → Isolate → Ask with context (error, code, expected vs. observed) → write a failing regression test → fix → run the related suite.
- Report test results with the actual command run and its outcome.
- **Real-device matrix (manual):** app killed, screen locked, battery saver on, after reboot, notifications permission denied. Record results in `docs/AI_LOG.md`.

## 9. Code Quality (Module 8 bonus)

- **Single responsibility:** one function/class/widget, one job.
- **DRY:** extract shared logic instead of duplicating it.
- **Smells to flag:** long functions/build methods, deep nesting, magic numbers (snooze/repeat/missed durations must be named, configurable constants).
- **Readability first:** optimize for the next human reader, not cleverness.

---

## 10. Git, Docs & Traceability (Module 6)

- **Commits:** Conventional Commits — `type(scope): summary` (`feat`, `fix`, `docs`, `test`, `refactor`, `chore`). Imperative mood, under 72 chars.
- **PRs:** description generated from the diff, then reviewed by me. List what was verified and what was not.
- **Docs:** any behavior change updates the README/docs in the same PR. Flag facts you cannot confirm from code or tests instead of guessing.
- **AI log:** maintain `docs/AI_LOG.md` (template in `SKILL.md`). Record meaningful prompts, decisions, and **suggestions I rejected or changed and why**. This feeds the portfolio case study.

---

## 11. Optional Sync & Analytics (replaces "AI-powered features"; not in MVP)

The app is offline-first with no account. A later, **opt-in** upload of adherence statistics is planned (Firebase or Supabase, undecided).

- Off by default; enabled only after explicit consent that explains what is sent; can be disabled and uploaded data can be deleted on request.
- Payload: anonymous random id, dose status, scheduled/acted timestamps (UTC + offset). **Never** medicine names, strengths, notes, or free text.
- Uses a local queue; never blocks the UI or reminders; retries when online; handles failures silently for the user.
- Keys/config are not committed. Remote rules restrict anonymous clients to inserting their own events.
- Test: offline queueing, retry, consent off → nothing sent, delete-my-data, malformed/oversized payload.
- If an AI-powered feature is ever added, call the provider from a server only, never ship an API key in the app.

---

## 12. Context Hygiene (Module 2)

- Read only the files that matter; do not load the whole repo.
- When a session gets long, summarize decisions so far and restart from the summary.
- Record stable decisions here in Agent.md (not in chat), so they survive between sessions.
- Treat the first answer as a draft: critique and refine it instead of starting over.

---

## 13. How to Communicate With Me

- Reply to me in **Arabic** by default (code, identifiers, commit messages, and docs filenames in English), unless I write in English.

Structure substantial answers as:

1. **Objective** — the requirement or goal being addressed
2. **Approach** — how an AI-assisted developer would tackle it, and why
3. **Implementation** — code, diff, commands, or config
4. **Verification** — what you ran and what it showed (or what I should run)
5. **Next steps** — the next milestone, and ask for confirmation before moving on

Style: concise, Markdown, code blocks, no filler. Mention edge cases and better alternatives briefly, without expanding scope on your own. If you are unsure or blocked, stop and say so.

---

## 14. Skills

Load the skill in `SKILL.md` (`mindai-dev-workflow`) when the task matches one of its workflows: prompt shaping, requirements & decomposition, generation/refactoring, debugging, test generation, docs & git, reminder engine / sync, security & privacy review, portfolio case study.

---

## 15. Project-Specific Rules  (add as you learn)

- **Reminder model:** a schedule stores the **local wall-clock time** (`"08:00"`) plus days of week. A dose event stores both `scheduled_at_utc` and `utc_offset_minutes`. Adherence stats are computed from stored events, not recomputed from current timezone.
- **Reschedule triggers:** device reboot, timezone change, system time change, app update, app open, and any schedule edit/delete. Missing one of these is a bug.
- **Rolling window:** schedule only the next N days of alarms (default 7) and refill; never schedule indefinitely.
- **Dose state machine:** `pending → ringing ⇄ snoozed → taken | missed`. Terminal states are final except an explicit manual correction from History. "Taken" must be idempotent.
- **Defaults (assumptions, confirm):** snooze 10 min, repeat every 5 min, warning after 3 unanswered repeats, mark missed after 60 min. All configurable constants, never inline numbers.
- **Escalation message** is sent once per dose, not on every repeat.
- **Permissions:** the app must work (with a persistent visible warning) when permissions are denied; it must never fail silently. Verify exact-alarm, notification, full-screen-intent, and boot permissions against current Android docs before implementing.
- **Soft delete:** deleting a medication stops future alarms but keeps its history for reports.
- **Localization:** Arabic (RTL) + English; all strings via ARB files; format dates/numbers per locale; test mixed Arabic/Latin/number medicine names.
- **Disclaimer:** reminder-only; shown in onboarding and Settings. No medical content anywhere.
- **Language of docs:** product analysis is in Arabic (`docs/App_Analysis_AR.md`); code, identifiers, and technical docs in English.

Every time you correct the agent twice for the same mistake, add a rule here.
