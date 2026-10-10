---
name: review-checklist
description: Reviews a diff for correctness, time handling, localization, security and health-data privacy before merge. Use at the Review stage or when asked to review AI-written code in the Medication Reminder app.
---

# Review checklist

Answer each item with evidence (file + line), not "looks fine".

## Correctness and quality
- [ ] Runs and solves the spec scenarios; each scenario has a test or a manual real-device check
- [ ] All imports, packages, plugin APIs and Android permissions are real (check `pubspec.lock` and current docs)
- [ ] Follows existing conventions; does not duplicate an existing utility
- [ ] Small functions, single responsibility, no magic numbers (snooze/repeat/missed are named constants)
- [ ] Tests added/updated; regression test for every bug fix; no weakened tests
- [ ] Time handling correct: local wall-clock vs UTC + offset, DST, midnight
- [ ] Works in Arabic (RTL) and English; strings come from ARB files
- [ ] Could I explain this code to a teammate?

## Reminder reliability
- [ ] No stale Alarm fires after an edit/delete
- [ ] Reschedule triggers intact: reboot, time-zone change, system-time change, app update, app open, edit/delete
- [ ] "Taken" is idempotent; Escalation Warning sent once per Dose
- [ ] Permission denied → persistent visible warning, never a silent failure

## Security and privacy
- [ ] No SQL built by string concatenation; inputs validated and size-limited
- [ ] Medication names/notes render safely (very long, mixed Arabic/Latin)
- [ ] No secrets in diff or history
- [ ] No medication names, Strength, notes or health text in logs, analytics, crash reports, uploads (consider lock-screen notification content)
- [ ] Uploads (if any) are opt-in, anonymous, limited to the agreed payload; nothing sent when consent is off
- [ ] Permissions are the minimum needed, each explained to the user
- [ ] New dependencies are real, maintained, necessary (no typo-squats)
- [ ] No medical advice anywhere

## Report
State what changed, what was run (exact commands + results), what was NOT verified, and risks.
