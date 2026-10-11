# DESIGN.md — Medication Reminder (تذكير الدواء)

> Single source of truth for the app's visual design system.
> Read this before creating or changing any screen, component, color, or text.
> Platform: Android (Flutter) · Primary language: Arabic (RTL) · Secondary: English (LTR) · Themes: light + dark (follow system).

---

## 1. Design Principles

1. **Calm and trustworthy.** The app deals with health. Never alarming unless a dose is genuinely missed.
2. **Soft and friendly.** Large rounded corners, comfortable spacing, warm feedback. Medication should feel cared-for, not clinical.
3. **One clear action per moment.** The "Taken" action is always the most prominent element on a dose card or alarm.
4. **Readable by everyone.** Users include elderly patients and caregivers. Large text, high contrast, big touch targets.
5. **Reliable first.** Animation and delight never delay or block a reminder or the "Taken" action.
6. **Reminder only.** The app never gives medical advice and never suggests dose changes.

---

## 2. Style Direction: Calm Utility

- Calm, friendly surfaces with clear hierarchy and generous touch targets.
- Light mode uses a subtle cool-green background and soft shadows; dark mode uses tonal blue layers with no shadows.
- Use rounded Material icons and simple flat illustrations only for empty and onboarding screens.
- Motion is brief and functional; it never delays saving a dose or firing a reminder.
- No gradients, photos, or heavy textures.

---

## 3. Color

### 3.1 Brand palette (Dhakkirni source design)

| Token | Hex | Role |
|---|---|---|
| `background` | `#F6F8F3` | Light-mode app background |
| `surface` | `#FFFFFF` | Cards and inputs in light mode |
| `outline` | `#D5DDE3` | Dividers and input outlines |
| `primary` | `#2B6F8A` | Brand, active items, links |
| `primaryDark` | `#7DBAD3` | Primary in dark mode |
| `primaryTint` | `#DCEBF1` | Soft primary backgrounds |
| `accent` | `#E9A27B` | Main action, alarm, FAB, attention |
| `onAccent` | `#1B2F45` | Text and icons on accent |
| `text` | `#1B2F45` | Main text in light mode |
| `textSecondary` | `#5A6B7B` | Secondary text in light mode |
| `darkBackground` | `#0F1E2E` | Dark-mode app background |
| `darkSurface` | `#1A2D40` | Dark-mode cards and app bars |
| `darkRaised` | `#223A52` | Raised dark surfaces and tint |
| `darkText` | `#E8EEF3` | Main text in dark mode |
| `darkTextSecondary` | `#A9B8C6` | Secondary text in dark mode |

### 3.2 Semantic colors

| Token | Hex | Use |
|---|---|---|
| `successBackground` | `#DCEBDD` | Taken chip/background in light mode |
| `successText` | `#2F6B3F` | Taken text in light mode |
| `successIcon` | `#3F8A52` | Success icons |
| `successBackgroundDark` | `#1F3D2C` | Taken chip/background in dark mode |
| `successTextDark` | `#BFE3C6` | Taken text and icons in dark mode |
| `errorBackground` | `#F8E4E1` | Missed-dose background in light mode |
| `errorText` | `#A8433B` | Error text in light mode |
| `error` | `#B5483F` | Destructive actions |
| `errorDark` | `#F2A39B` | Error and destructive actions in dark mode |
| `warningBackground` | `#FBEBDD` | Snoozed / low-stock background in light mode |
| `warningText` | `#8A4B1F` | Warning text in light mode |
| `warningBackgroundDark` | `#3B2E24` | Warning background in dark mode |
| `warningTextDark` | `#F0B08C` | Warning text in dark mode |
| `white` | `#FFFFFF` | Cards (light), text on primary |

### 3.3 Theme mapping

| Role | Light | Dark |
|---|---|---|
| Scaffold background | `background` `#F6F8F3` | `darkBackground` `#0F1E2E` |
| Card / surface | `surface` | `darkSurface` `#1A2D40` |
| Primary | `primary` | `primaryDark` |
| On primary | `white` | `darkBackground` |
| Accent / main action | `accent` | `accent` |
| On accent | `onAccent` | `onAccent` |
| Main text | `text` | `darkText` |
| Secondary text | `textSecondary` | `darkTextSecondary` |
| Divider / outline | `outline` | `darkOutline` `#2E4A66` |
| Error | `error` | `errorDark` |
| Taken (chip bg / text) | `successBackground` / `successText` | `successBackgroundDark` / `successTextDark` |

### 3.4 Color rules

- **Accent is for action and attention only.** Never use it as body text or small text.
- **Text on accent is always `onAccent`**, never white.
- Never use color alone to convey status. Always pair with an icon and a text label.
- Do not introduce new colors without adding them here first.

### 3.5 Verified contrast (approximate WCAG ratios)

| Pair | Ratio | Verdict |
|---|---|---|
| `onAccent` on `accent` | ~4.6:1 | Pass (AA) |
| `white` on `primary` | ~5.1:1 | Pass (AA) |
| `text` on `background` | high contrast | Pass (AA) |
| `text` on `surface` | high contrast | Pass (AA) |
| `darkText` on `darkSurface` | high contrast | Pass (AA) |
| `errorText` on `errorBackground` | high contrast | Pass (AA) |
| `accent` on `surface` | low contrast | **Fail for text. Icons/large shapes only** |

---

## 4. Typography

**Font family: IBM Plex Sans Arabic** (Arabic + Latin). Use it for everything.

- Use weights 400, 500, and 700. There is no need to introduce a 600 weight.
- No italics for Arabic text.
- Bundle the font files in `assets/fonts/` and declare them in `pubspec.yaml` before release. The app is offline-first, so do not rely on downloading fonts at runtime.

### 4.1 Type scale

| Style | Size / Line height | Weight | Use |
|---|---|---|---|
| `displayAlarm` | 56 / 64 | 800 | Time on the alarm screen |
| `display` | 32 / 40 | 700 | Onboarding titles, large numbers (adherence %) |
| `headline` | 24 / 32 | 700 | Screen titles |
| `title` | 20 / 28 | 700 | Card titles (medicine name) |
| `subtitle` | 18 / 26 | 500 | Important details (time, strength) |
| `body` | 16 / 24 | 400 | Default text (**minimum for readable content**) |
| `label` | 14 / 20 | 500 | Buttons, chips, form labels |
| `caption` | 12 / 16 | 400 | Non-essential hints only |

### 4.2 Typography rules

- Body text never below 16sp. Caption (12sp) is never used for medicine names, times, or doses.
- Support system font scaling up to **200%** without clipped or overlapping text. Use flexible layouts, never fixed heights on text containers.
- Numerals: Western digits (0–9) by default in both languages. *(Assumption. Confirm.)*
- Keep line length comfortable; avoid long unbroken paragraphs.

---

## 5. Layout, Spacing & Shape

### 5.1 Spacing (4pt base)

`4 · 8 · 12 · 16 · 20 · 24 · 32 · 40`

- Screen horizontal padding: **20**
- Card inner padding: **16–20**
- Gap between cards: **12**
- Section gap: **24**

### 5.2 Corner radius

| Element | Radius |
|---|---|
| Cards | 16 |
| Buttons | 16 |
| Input fields | 14 |
| Chips / day selectors / status pills | fully rounded (999) |
| Bottom sheets / dialogs | 28 |
| Illustration containers | 24 |

### 5.3 Elevation

- **Light:** soft shadow `0 4 16 rgba(27, 47, 69, 0.06)` on cards.
- **Dark:** no shadows. Separate layers by tone (`darkBackground` background → `darkSurface` cards).

### 5.4 Touch targets

- Minimum **48×48dp** for anything tappable.
- Primary buttons are **56dp** high and full width on forms and alarms.

---

## 6. RTL & Localization

- Arabic is the default; layout is fully RTL. English switches to LTR using the same components.
- Use directional properties (`start` / `end`), never `left` / `right`.
- **Mirror in RTL:** back arrows, chevrons, progress direction, list swipe directions.
- **Do not mirror:** pill, clock, check, plus, and other non-directional icons; charts' time axis follows reading direction.
- Bottom navigation order follows reading direction (first item on the right in Arabic).
- All strings go through localization files. No hard-coded text in widgets.

---

## 7. Iconography & Illustration

### 7.1 Icons

- Set: **Material Symbols Rounded** (consistent with the soft style).
- Size: 24dp default, 28–32dp inside prominent cards; stroke/weight 400–500.
- Active nav item: filled variant in `primary`; inactive: outlined, secondary text color.
- Core icons: pill, clock/alarm, check-circle, close/cancel, snooze, more-vert, add, bar-chart, settings, inventory, warning, notifications.

### 7.2 Illustrations

- Used **only** on empty states and onboarding screens.
- Style: flat, friendly shapes with soft rounded edges, using only the brand palette plus `success`. No outlines heavier than 2px, no gradients, no faces with detailed expressions.
- Needed set: onboarding (3 slides), empty medications, empty today, empty reports, notification-permission request, alarm/exact-alarm permission request.

---

## 8. Components

### 8.1 Buttons

| Type | Style |
|---|---|
| **Primary (Taken / Save)** | Fill `accent`, text `onAccent` 18sp w700, height 56, radius 16 |
| **Secondary (Snooze)** | Outlined 1.5px `primary`, text `primary`, height 56, radius 16 |
| **Text button** | `primary` text, no container, min target 48 |
| **Destructive** | Fill `error`, text `white` (only inside confirm dialogs) |
| **FAB (Add medication)** | `accent`, icon `onAccent`, 64×64, radius 20 |

Pressed state: scale to 0.96 with 120ms ease-out, then spring back. Disabled: 38% opacity.

### 8.2 Dose card (core component)

- Container: `surface` (light) / `darkSurface` (dark), radius 16, padding 16–20.
- Row 1: pill icon in a 48dp circle (tint of `primary`), medicine name (`title`), 3-dot menu at the end.
- Row 2: strength (`subtitle`), scheduled time (`subtitle`), status chip.
- Upcoming/due card adds: **Taken** (primary) + **Snooze** (secondary) buttons below.
- 3-dot menu: Edit time, Delete.

### 8.3 Status chips

| State | Background (light) | Text/Icon | Icon |
|---|---|---|---|
| Upcoming | `accent` | `onAccent` | clock |
| Taken | `successBackground` | `successText` / `successIcon` | check |
| Missed | `errorBackground` | `errorText` | close |
| Snoozed | `warningBackground` | `onAccent` | snooze |

Pill shape, height 32, horizontal padding 12, `label` style, icon 18dp before text.

### 8.4 Today progress card

- Large card at the top of Home: "3 من 5 جرعات اليوم", linear progress bar (`primary` fill on `primaryTint` track), height 12, fully rounded.

### 8.5 Inputs

- Filled `surface` (light) / `darkSurface` (dark), radius 14, 1px outline at rest, 2px `primary` on focus, height 56.
- Labels above or floating; error text in `errorText` with an icon.
- Day-of-week selectors: 7 circular chips, 44–48dp; selected = `primary` fill + white text; unselected = outlined.

### 8.6 Stock indicator

- Progress bar + text "متبقي 12 حبة".
- Below threshold: bar and chip switch to `accent` with label "الكمية منخفضة" and a warning icon.

### 8.7 Bottom navigation

- 4 items: اليوم · أدويتي · التقارير · الإعدادات.
- Height 72, container `surface`/`darkSurface`, top radius 24, selected item has a pill indicator in `primaryTint` and filled icon.

### 8.8 Dialogs & bottom sheets

- Radius 28, padding 24. Title `title`, body `body`.
- Destructive confirm: two buttons, **Cancel** (text) and **Delete** (destructive), Delete never the default focus.

### 8.9 Snackbar / toast

- Bottom floating, radius 16, `text` background with white text (light) / `darkRaised` background with `darkText` text (dark). Max 4 seconds. Include "تراجع" (Undo) when the action is reversible.

### 8.10 Alarm screen (full screen)

- Background `darkBackground` in both themes.
- Top: current time (`displayAlarm`, white).
- Center: pill icon in a pulsing 160dp `accent` circle.
- Medicine name (`headline`, white) and strength + scheduled time (`subtitle`, white 80%).
- Buttons stacked at bottom: **Taken** (accent primary) → **Snooze 10 min** (white outlined) → "إيقاف" text link.
- **Escalation variant** (after repeated non-response): add a banner in `error` with the warning message (see section 11), keep the same buttons.

### 8.11 Reports

- Adherence ring: 180dp, 14dp stroke, `primary` progress on `primaryTint` track, percentage in `display`.
- Weekly bar chart: taken bars `successIcon`, missed bars `error`, rounded tops (radius 8), day labels `label`.
- Stats row: three small cards (Taken, Missed, Snoozed) each with icon + number.
- Log list grouped by day; each row: name, scheduled vs actual time, status icon.

---

## 9. Motion

| Moment | Behavior |
|---|---|
| **Dose taken (celebration)** | Check icon morphs and scales in (spring), a short confetti burst in `accent` / `successBackground` / `primary`, card collapses to Taken state. Total ~700ms. Light haptic. |
| Button press | Scale 0.96, 120ms, then spring back. |
| Screen transition | Shared-axis, 250ms, ease-out. Horizontal direction follows RTL/LTR. |
| List item added/removed | Fade + slide, 200ms. |
| Progress bar/ring updates | Animate 400ms ease-in-out. |
| Alarm icon | Gentle pulse (scale 1.0 → 1.08, 1.2s loop). |
| Empty-state illustration | One subtle entrance animation, no loops. |

Rules:
- Animation must **never delay** the Taken action being saved or a reminder firing.
- Honor the system "reduce motion" setting: replace celebration/pulse with a simple fade and still show the success state.
- Keep confetti short and non-blocking; no sound on the celebration (the alarm sound is separate).

---

## 10. Accessibility

- All text meets AA contrast (see 3.5). Do not use combinations marked as failing.
- Touch targets ≥ 48dp, spacing between adjacent targets ≥ 8dp.
- Every icon-only button has a semantic label (Arabic and English).
- Status is never color-only (icon + text always).
- Support TalkBack: logical focus order in RTL, announce "تم أخذ الدواء" on completion.
- Support text scaling to 200%.
- The alarm screen must be fully usable with one hand and large targets.

---

## 11. Voice & Microcopy

**Tone: simplified, friendly Modern Standard Arabic (فصحى مبسطة وودية).** Short sentences, warm, never scolding, never medical advice. Prefer neutral phrasing that does not depend on the user's gender.

| Situation | Arabic copy |
|---|---|
| Notification (due) | حان موعد دواء {name}، نريد أن تبقى بخير |
| Taken button | تم أخذ الدواء |
| Snooze button | ذكّرني بعد 10 دقائق |
| Dose logged | أحسنت! سُجّلت الجرعة |
| Missed dose | فاتت جرعة {name} المقرّرة في {time} |
| Repeated non-response warning | تأخير الجرعات أو نسيانها قد يضر بالصحة، نرجو أخذ الدواء الآن |
| Low stock | بقي {n} فقط من {name}، لا تنسَ تجديده |
| Empty: medications | لا توجد أدوية بعد. أضف أول دواء لنبدأ معًا |
| Empty: today | لا جرعات اليوم. نتمنى لك يومًا هادئًا |
| Delete confirm | هل تريد حذف هذا الدواء؟ ستتوقف تذكيراته |
| Permission request | نحتاج إذن التنبيهات لنذكّرك في الوقت المناسب |
| Generic error | حدث خطأ بسيط. حاول مرة أخرى |

Rules:
- The app is a reminder tool. Never say or imply "you should take more/less", never interpret symptoms.
- The missed-dose warning is informational and calm, not frightening.
- English versions follow the same warm, short style.

---

## 12. Screen Inventory

1. Onboarding (3 slides) + permissions (notifications, exact alarms)
2. Home / Today (اليوم)
3. My Medications (أدويتي) + stock
4. Add / Edit Medication
5. Alarm (full screen) + escalation variant
6. Reports (التقارير) + adherence log
7. Settings (الإعدادات): alarm sound, snooze duration, repeat interval, vibration, language, data/sync, about

---

## 13. Flutter Implementation Notes

- Tokens live in `lib/app_theme.dart` (`AppColors`, `AppTheme.light()`, `AppTheme.dark()`).
- Use `Theme.of(context).colorScheme` or `AppColors`. **Never hard-code hex values in widgets.**
- Register IBM Plex Sans Arabic in `pubspec.yaml` (weights 400, 500, 700) and set `fontFamily: 'IBM Plex Sans Arabic'` in `ThemeData`.
- Icons: `Icons.*_rounded` (Material Icons Rounded).
- Use `Directionality` from the locale; prefer `EdgeInsetsDirectional`, `AlignmentDirectional`.
- Keep radii in the theme aligned with section 5.2 (cards 16, buttons 16, inputs 14).

---

## 14. Open Items / Assumptions to Confirm

- Western vs. Eastern Arabic numerals.
- Final launcher icon and logo.
- Exact illustration set and who draws it.
- Default snooze duration (assumed 10 minutes).
- Whether caregivers get a distinct view in the first version.
