---
name: write-tests
description: Test generation playbook for the Medication Reminder app (unit, edge cases, regression, test data) using flutter_test and a fake clock. Use when asked to add tests or coverage.
---

# Write tests

Order: **unit tests → edge cases → regression test → test data.**

## Prompt template
```
Write tests for <function/module> using flutter_test (and the mocking approach already in the project).
Cover: happy path, boundary values, empty/null, invalid input, special characters / mixed Arabic-Latin text,
failure paths. Use an injectable fake clock/timezone, never the real device time.
Follow the style of <existing test file>. List any behavior you had to assume.
```

## Shape
Many unit tests (domain, scheduling logic, adherence calc) > fewer widget tests (forms, alarm screen buttons, RTL) > fewest integration tests. Alarm delivery itself is checked **manually on real devices**.

## Boundaries to always test
Missed cutoff at 59/60/61 minutes · snooze count limits · Stock 0 / 1 / threshold · 23:59 and 00:00 · DST day · two Doses same minute · double-tap Taken.

## Verify
Temporarily break the logic and confirm the test fails, then restore it. Tests that cannot fail are worthless. Report the exact command run and its outcome.
