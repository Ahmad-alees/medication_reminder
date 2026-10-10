---
name: reminder-engine
description: Playbook for building or changing the reminder engine (scheduling, alarms, notifications, reschedule, escalation, permission health check). Use for any task touching lib/scheduling or alarm/notification behavior.
---

# Reminder engine

This is the core of the app. Changing its behavior requires approval (`AGENTS.md` "Ask first") and runs at L3 on a branch.

## Blueprint
```
Schedule (local "HH:mm" + Active Days)
   │ generate Doses for next N days (pure function)
   ▼
Dose events (local date/time + scheduled_at_utc + utc_offset_minutes)
   │ schedule exact alarms (thin plugin wrapper behind an interface)
   ▼
Alarm fires → alarm screen / notification (sound, full-screen)
   │ Taken | Snooze | no response
   ▼
State machine: pending → ringing ⇄ snoozed → taken | missed
   │ repeat every N min → one Escalation Warning after K repeats → missed after cutoff
   ▼
Log + Stock update + Adherence stats
```

## Build order
1. Pure domain: Dose generation + state machine + adherence calc, with tests (fake clock).
2. Persistence: Dose events, settings, idempotent updates.
3. Plugin wrapper: schedule/cancel/replace alarms behind an interface (so logic is testable with a fake).
4. Reschedule triggers: boot, time-zone/time change, app update, app open, Reminder edit/delete.
5. Alarm UI + Taken/Snooze actions (also from the notification).
6. Escalation + Missed cutoff.
7. Permission/health check screen and persistent warning banner.

## Test matrix (record results in `docs/AI_LOG.md`)
reboot · app killed · battery saver · DST change · time-zone change · manual clock change · two Doses same minute · double-tap Taken · edit/delete while ringing · permission denied · 23:59/00:00 · snooze across midnight.

## Verify
Run the real-device matrix and record device + Android version. Confirm no stale alarm fires after an edit/delete. Never claim "works" from emulator or unit tests alone.
