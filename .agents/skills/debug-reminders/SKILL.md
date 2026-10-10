---
name: debug-reminders
description: Debugging playbook (reproduce, isolate, hypothesize, fix with regression test) especially for alarms, notifications and time handling. Use for errors, stack traces, "reminder didn't fire", or wrong results.
---

# Debug

Flow: **Reproduce → Isolate → Ask with context → Verify the fix.**

## Debug prompt template
```
EXPECTED:   <what should happen>
OBSERVED:   <exact error / stack trace / logcat excerpt (no medicine names)>
REPRO:      <minimal steps or input; device model + Android version>
CODE:       <smallest relevant snippet or file path>
ENV:        <Flutter/Dart version, plugin versions, battery-saver / permission state>
ASK:        List the most likely causes, ranked, and how to confirm each.
            Write a failing regression test FIRST where possible. Do not change code yet.
```

## Rules
- Hypothesis first, fix second; confirm the cause with evidence.
- Never "fix" by suppressing errors, loosening assertions, or deleting tests.
- Fix → regression test passes → related suite passes → re-check on a real device for alarm/notification issues.

## Examples
- **Boundary bug:** a Dose at 23:59 appears under the next day in the report → check whether the date is derived from UTC instead of the stored local date/offset; test 23:59, 00:00, 00:01 and a DST-change day.
- **Alarm bug:** reminders stop after reboot → hypotheses: boot receiver missing/not registered, reschedule not triggered, permission revoked, OEM battery restriction. Confirm each with logs before changing code.
