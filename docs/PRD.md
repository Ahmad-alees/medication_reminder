# PRD — Medication Reminder (Thakirny)

> Detailed Arabic analysis and user stories US-01…US-10: `docs/App_Analysis_AR.md` (extend those, do not duplicate).
> Items marked *(proposed — confirm)* are not yet approved by the author.

## 1. Vision
A simple, reliable, offline medication reminder that makes forgetting a Dose hard, and shows the user how consistently they take their Doses.

## 2. Users
- **Patient** — takes the medications.
- **Caregiver** — manages one person's medications; same Account type as the Patient. One Account = one person.

## 3. Problem
People with several medications forget dose times, and there is no easy record of what was taken or missed.

## 4. Goals / Non-goals
**Goals:** reminders that fire reliably with no internet (including after reboot); Taken / Snooze; follow-up when the user does not respond; Stock tracking; Adherence Log and Reports; Arabic + English with RTL.
**Non-goals:** medical advice, diagnosis, dosage recommendations, drug-interaction information, external drug database, iOS/web, accounts shared across people, required cloud sync.

## 5. Core features
1. Add a Medication manually: name, Strength, Reminder Time, Active Days.
2. Alarm repeats until **Taken** or stopped; **Snooze**.
3. Escalation Warning after repeated non-response (generic wording), then Missed after the cutoff.
4. Three-dot menu on a Reminder: edit time, delete (history kept).
5. Stock per Medication.
6. Adherence Log and Adherence Reports (taken / snoozed / missed).
7. Optional, opt-in anonymous Usage Statistics (not MVP).

## 6. First-release acceptance criteria *(proposed — confirm)*
1. Given a Reminder at 08:00 and the phone locked/restarted, when 08:00 arrives, then the Alarm fires.
2. Given a ringing Alarm, when the Patient taps **Taken**, then the repeating stops and the Dose is logged as Taken (tapping twice changes nothing).
3. Given no response, when the repeat count is reached, then exactly one Escalation Warning appears, and after the cutoff the Dose becomes Missed.

## 7. Milestones
M0–M6 are defined in `docs/App_Analysis_AR.md` (first small release: M0–M4, per the portfolio plan). *(Not provided in this repo snapshot.)*

## 8. Risks and open questions
See `AGENTS.md` §5. Main risks: OEM battery restrictions, time-zone/DST handling, permission denial, lock-screen privacy of notification text.
