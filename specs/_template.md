# Spec: <short title>

<!--
FOR THE AGENT: derive ONLY from an approved intent/<slug>.md. Copy to specs/<slug>.md.
Every scenario must trace to a sentence in the intent. Use docs/glossary.md terms exactly
(Dose, Strength, Alarm, Escalation Warning, Taken/Snoozed/Missed...). No implementation details.
-->

- **Slug:** <same slug as the intent>
- **Source intent:** intent/<slug>.md
- **Date:** <YYYY-MM-DD>

## Acceptance criteria (Gherkin)

```gherkin
Feature: <name>

  Scenario: <happy path>
    Given a Reminder for a Medication at 08:00 on Active Days
    When 08:00 arrives
    Then the Alarm fires for that Dose

  Scenario: <failure / edge case>
    Given <state>
    When <action>
    Then <result>
```

## Derived edge cases (not stated by the author — confirm each)
<!-- Check the ones that apply: device reboot · time-zone change · manual clock change · DST change ·
23:59 / 00:00 · two Doses at the same minute · double-tap on Taken · edit/delete a Reminder while its Alarm rings ·
notification/exact-alarm permission denied · battery saver · app killed · very long or mixed Arabic/Latin Medication name -->
-

## Out of scope
-

## Open questions
-

Status: draft
