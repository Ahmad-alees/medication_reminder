---
name: intent-interview
description: Interviews a non-engineer and writes an intent.md. Use when someone describes a new feature, problem, or change request for the Medication Reminder app before any spec exists.
---

# Intent interview

Turn a rough idea into a clear `intent/<slug>.md`, using the author's own words.
You are collecting intent only. Do not write code, a spec, a plan, or Gherkin.

## Before you ask anything
1. Read `AGENTS.md` for the project rules and scope.
2. Read `docs/glossary.md` and use its terms exactly. Do not invent terms.
3. Read `intent/_template.md` so you know which sections you must fill.
4. If the author's first message already answers some sections, do not ask about them again.

## How to interview
- Ask **one question at a time**. Wait for the answer before the next one.
- **Stop after 8 questions.** Follow-up questions count toward the 8.
- Use simple, non-technical language. Reply in the language the author writes in.
- If an answer is vague, ask one short follow-up for a concrete example
  (for instance: "What happens at 8:00 pm when the phone is locked?").
- Do not suggest solutions or technical designs. Do not give medical advice.
- If the author does not know, record it as an open question and move on.

## What to cover (in this order, skipping what is already answered)
1. The problem: what is going wrong or missing today.
2. Who is affected: Patient, Caregiver, or both.
3. What should happen instead, step by step.
4. One or two real-life scenarios.
5. What happens when things go wrong: phone restart, no internet, battery saver, app closed, user ignores it, time zone changes.
6. What is explicitly out of scope for now.
7. Effects on: reminder reliability, Arabic/English and RTL, data and sync, medical wording.
8. How the author would know it works, in plain words.

## Writing the file
1. Choose a short kebab-case slug (for example `repeat-until-taken`).
2. Create `intent/<slug>.md` by copying the structure of `intent/_template.md`. Never edit `_template.md` itself.
3. Fill each section from the author's answers, **in the author's own words**. Do not rephrase into technical language and do not add requirements the author did not state.
4. Write "Not answered" for any section without an answer, and list it under Open questions.
5. Remove the HTML guidance comments from the finished file.
6. Show the author a short summary of what you wrote and where the file is.

## Ending rules
- End the file with an **Open questions** section and then the line `Status: draft`.
- **Never** mark an intent as approved. Only the author changes the status.
- If the request conflicts with `AGENTS.md` (needs iOS, asks for medical advice...), say so in Open questions instead of silently accepting it.
- Do not move on to a spec or code. Tell the author the next step is their review and approval.
