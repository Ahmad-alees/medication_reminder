# Glossary — Medication Reminder App

> Single source of truth for project vocabulary.
> Use these exact terms in code, tests, intent files, specs, and UI copy.
> If a term is missing or unclear, ask the human; do not invent a definition.

## People

| Term | Arabic | Definition |
|------|--------|------------|
| **Patient** | المريض | The person who takes the medications. |
| **Caregiver** | مقدّم الرعاية | Someone who manages the patient's medications in the app (family member, nurse). Uses the same account type as the patient. |
| **Account** | الحساب | One account holds the medications of exactly one person. A caregiver managing two people needs two accounts. |

## Medication setup

| Term | Arabic | Definition |
|------|--------|------------|
| **Medication** | الدواء | A medicine the user entered manually (name, strength, schedule). There is no external drug database. |
| **Strength** | التركيز | The amount per unit as written on the package, e.g. "500 mg". Entered by the user; the app never suggests or validates it. |
| **Reminder** | التذكير | The recurring schedule attached to a Medication: a time of day plus the days of the week. |
| **Reminder Time** | وقت التذكير | The time of day a Reminder fires. |
| **Active Days** | أيام التكرار | The days of the week on which a Reminder fires. |

## Doses and reminders at runtime

| Term | Arabic | Definition |
|------|--------|------------|
| **Dose** | الجرعة | One scheduled intake of a Medication at a specific date and time. It is an *event*, not an amount. (The amount is the **Strength**.) |
| **Dose Status** | حالة الجرعة | One of: **Pending**, **Taken**, **Snoozed**, **Missed**. |
| **Pending** | بانتظار | The Dose is due or upcoming and the user has not acted. |
| **Taken** | تم أخذها | The user tapped **Taken** for this Dose. Stops the repeating alarm. |
| **Snoozed** | مؤجّلة | The user tapped **Snooze**; the reminder will fire again later. |
| **Missed** | فائتة | The user never confirmed the Dose. |
| **Alarm** | المنبّه | The alarm-clock-style sound and notification that repeats until the user taps **Taken** or stops it. |
| **Local Notification** | إشعار محلي | A notification scheduled on the device itself. It works with no internet. |
| **Escalation Warning** | تحذير المتابعة | The extra notification shown after repeated non-response, with generic wording that missing or delaying doses may affect treatment. It never contains medical advice. |

## Tracking and reports

| Term | Arabic | Definition |
|------|--------|------------|
| **Adherence** | الالتزام | How consistently the user takes Doses on time. |
| **Adherence Log** | سجل الالتزام | The chronological record of every Dose and its final status. |
| **Adherence Report** | تقرير الالتزام | A summary view built from the Adherence Log (e.g. taken vs. missed over a period). |
| **Stock** | المخزون | The remaining quantity of a Medication that the user tracks manually. |

## Data and sync

| Term | Arabic | Definition |
|------|--------|------------|
| **Local Store** | التخزين المحلي | The on-device database. It is the source of truth. |
| **Sync** | المزامنة | Uploading data from the Local Store to a server after it is saved locally. Never required for the app to work. Backend not yet decided. |
| **Usage Statistics** | إحصاءات الاستخدام | Data uploaded for aggregate analysis. Exact contents are an open decision. |

## Terms to avoid

| Don't write | Write instead | Why |
|-------------|---------------|-----|
| "dosage" / "dose" meaning amount | **Strength** | **Dose** means a scheduled intake in this project. |
| "prescription", "treatment plan" | **Medication**, **Reminder** | The app doesn't handle prescriptions or give medical guidance. |
| "alert" | **Alarm**, **Local Notification**, **Escalation Warning** | Use the specific term. |
| "user" for the person in a requirement | **Patient** or **Caregiver** | Be explicit about who acts. |
| "skipped" | *(not defined)* | Not a status yet. Ask the human before adding it. |

## Open terms (not yet defined)

- Time-zone behavior for Reminders when the device zone changes.
- Low-stock threshold and what happens when Stock reaches it.
- Number of repeats before an Escalation Warning is sent.