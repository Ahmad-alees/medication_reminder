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

## 2. Style Direction: Soft & Friendly

- Generously rounded shapes (cards, buttons, chips, sheets).
- Soft, low-contrast shadows in light mode; tonal layers (no shadows) in dark mode.
- Simple rounded icons + gentle flat illustrations on empty and onboarding screens.
- Lively, celebratory motion when a dose is taken; playful press feedback on buttons.
- No gradients, no photos, no heavy textures.

---

## 3. Color

### 3.1 Brand palette (Coolors palette 3)

| Token | Hex | Role |
|---|---|---|
| `orange` | `#FF6F00` | Main action, alarm, FAB, attention |
| `lime` | `#EAF8BF` | Light-mode app background |
| `teal` | `#006992` | Primary brand (app bar, active items, links) |
| `blue` | `#27476E` | Dark-mode surfaces, tertiary |
| `navy` | `#001D4A` | Main text, dark-mode background, text on orange |

### 3.2 Added semantic colors (not in the palette)

| Token | Hex | Use |
|---|---|---|
| `success` | `#C2EABD` | "Taken" chip/background (from palette 4) |
| `successStrong` | `#2E7D32` | Success icons and text accents |
| `error` | `#D32F2F` | Missed dose, destructive actions |
| `errorText` | `#B71C1C` | Error text on light tinted backgrounds |
| `errorContainer` | `#FDECEA` | Missed-dose chip background (light) |
| `warningContainer` | `#FFE8D6` | Snoozed / low-stock chip background (light) |
| `tealLight` | `#5BB8DC` | Primary in dark mode (derived for contrast) |
| `errorDark` | `#FF8A80` | Error in dark mode |
| `successContainerDark` | `#1E4D35` | "Taken" chip background in dark mode |
| `white` | `#FFFFFF` | Cards (light), text on teal |

### 3.3 Theme mapping

| Role | Light | Dark |
|---|---|---|
| Scaffold background | `lime` `#EAF8BF` | `navy` `#001D4A` |
| Card / surface | `white` | `blue` `#27476E` |
| Primary | `teal` | `tealLight` |
| On primary | `white` | `navy` |
| Accent / main action | `orange` | `orange` |
| On accent | `navy` | `navy` |
| Main text | `navy` | `white` |
| Secondary text | `navy` at 70% | `white` at 70% |
| Divider / outline | `navy` at 12% | `white` at 16% |
| Error | `error` | `errorDark` |
| Taken (chip bg / text) | `success` / `navy` | `successContainerDark` / `success` |

### 3.4 Color rules

- **Orange is for action and attention only.** Never use orange as body text or small text.
- **Text on orange is always `navy`**, never white.
- Never use color alone to convey status. Always pair with an icon and a text label.
- Do not introduce new colors without adding them here first.

### 3.5 Verified contrast (approximate WCAG ratios)

| Pair | Ratio | Verdict |
|---|---|---|
| `navy` on `orange` | ~5.9:1 | Pass (AA) |
| `white` on `teal` | ~6.1:1 | Pass (AA) |
| `navy` on `lime` | ~14.7:1 | Pass (AAA) |
| `navy` on `white` | ~16.5:1 | Pass (AAA) |
| `white` on `blue` | ~9.5:1 | Pass (AAA) |
| `tealLight` on `navy` | ~7.3:1 | Pass (AAA) |
| `orange` on `navy` | ~5.9:1 | Pass (AA) |
| `errorText` on `errorContainer` | ~5.8:1 | Pass (AA) |
| `white` on `orange` | ~2.8:1 | **Fail. Do not use** |
| `orange` on `white` / `lime` | ~2.5–2.8:1 | **Fail for text. Icons/large shapes only** |

---

## 4. Typography

**Font family: Tajawal** (Arabic + Latin). Use it for everything.

- Available weights: 200, 300, 400, 500, 700, 800, 900. There is **no 600**.
- No italics for Arabic text.
- **Bundle the font files in `assets/fonts/`** and declare them in `pubspec.yaml`. The app is offline-first, so do not rely on downloading fonts at runtime.

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

### 5.2 Corner radius (large, for the Soft & Friendly style)

| Element | Radius |
|---|---|
| Cards | 20 |
| Buttons | 16 |
| Input fields | 14 |
| Chips / day selectors / status pills | fully rounded (999) |
| Bottom sheets / dialogs | 28 |
| Illustration containers | 24 |

### 5.3 Elevation

- **Light:** soft shadow `0 4 16 rgba(0, 29, 74, 0.08)` on cards; FAB `0 6 20 rgba(255, 111, 0, 0.30)`.
- **Dark:** no shadows. Separate layers by tone (`navy` background → `blue` cards).

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
- Active nav item: filled variant in `teal`; inactive: outlined, secondary text color.
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
| **Primary (Taken / Save)** | Fill `orange`, text `navy` 16sp w700, height 56, radius 16 |
| **Secondary (Snooze)** | Outlined 1.5px `primary`, text `primary`, height 56, radius 16 |
| **Text button** | `primary` text, no container, min target 48 |
| **Destructive** | Fill `error`, text `white` (only inside confirm dialogs) |
| **FAB (Add medication)** | `orange`, icon `navy`, 64×64, radius 20 |

Pressed state: scale to 0.96 with 120ms ease-out, then spring back. Disabled: 38% opacity.

### 8.2 Dose card (core component)

- Container: white (light) / `blue` (dark), radius 20, padding 16–20.
- Row 1: pill icon in a 48dp circle (tint of `teal` at 12%), medicine name (`title`), 3-dot menu at the end.
- Row 2: strength (`subtitle`), scheduled time (`subtitle`), status chip.
- Upcoming/due card adds: **Taken** (primary) + **Snooze** (secondary) buttons below.
- 3-dot menu: Edit time, Delete.

### 8.3 Status chips

| State | Background (light) | Text/Icon | Icon |
|---|---|---|---|
| Upcoming | `orange` | `navy` | clock |
| Taken | `success` | `navy` / `successStrong` icon | check |
| Missed | `errorContainer` | `errorText` | close |
| Snoozed | `warningContainer` | `navy` | snooze |

Pill shape, height 32, horizontal padding 12, `label` style, icon 18dp before text.

### 8.4 Today progress card

- Large card at the top of Home: "3 من 5 جرعات اليوم", linear progress bar (`teal` fill on 12% track), height 12, fully rounded.

### 8.5 Inputs

- Filled white (light) / `blue` (dark), radius 14, 1px outline at rest, 2px `primary` on focus, height 56.
- Labels above or floating; error text in `errorText` with an icon.
- Day-of-week selectors: 7 circular chips, 44–48dp; selected = `teal` fill + white text; unselected = outlined.

### 8.6 Stock indicator

- Progress bar + text "متبقي 12 حبة".
- Below threshold: bar and chip switch to `orange` with label "الكمية منخفضة" and a warning icon.

### 8.7 Bottom navigation

- 4 items: اليوم · أدويتي · التقارير · الإعدادات.
- Height 72, container `white`/`blue`, top radius 24, selected item has a pill indicator in `teal` at 14% and filled icon.

### 8.8 Dialogs & bottom sheets

- Radius 28, padding 24. Title `title`, body `body`.
- Destructive confirm: two buttons, **Cancel** (text) and **Delete** (destructive), Delete never the default focus.

### 8.9 Snackbar / toast

- Bottom floating, radius 16, `navy` background with white text (light) / `lime` background with `navy` text (dark). Max 4 seconds. Include "تراجع" (Undo) when the action is reversible.

### 8.10 Alarm screen (full screen)

- Background `navy` in both themes.
- Top: current time (`displayAlarm`, white).
- Center: pill icon in a pulsing 160dp orange circle.
- Medicine name (`headline`, white) and strength + scheduled time (`subtitle`, white 80%).
- Buttons stacked at bottom: **Taken** (orange primary) → **Snooze 10 min** (white outlined) → "إيقاف" text link.
- **Escalation variant** (after repeated non-response): add a banner in `error` with the warning message (see section 11), keep the same buttons.

### 8.11 Reports

- Adherence ring: 180dp, 14dp stroke, `teal` progress on 12% track, percentage in `display`.
- Weekly bar chart: taken bars `successStrong`, missed bars `error`, rounded tops (radius 8), day labels `label`.
- Stats row: three small cards (Taken, Missed, Snoozed) each with icon + number.
- Log list grouped by day; each row: name, scheduled vs actual time, status icon.

---

## 9. Motion

| Moment | Behavior |
|---|---|
| **Dose taken (celebration)** | Check icon morphs and scales in (spring), a short confetti burst in `orange` / `success` / `teal`, card collapses to Taken state. Total ~700ms. Light haptic. |
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

- Tokens live in `lib/core/theme/app_theme.dart` (`AppColors`, `AppTheme.light()`, `AppTheme.dark()`).
- Use `Theme.of(context).colorScheme` or `AppColors`. **Never hard-code hex values in widgets.**
- Register Tajawal in `pubspec.yaml` (weights 400, 500, 700, 800) and set `fontFamily: 'Tajawal'` in `ThemeData`.
- Icons: `Icons.*_rounded` (Material Icons Rounded).
- Use `Directionality` from the locale; prefer `EdgeInsetsDirectional`, `AlignmentDirectional`.
- Update radii in the theme to match section 5.2 (cards 20, buttons 16, inputs 14).

---

## 14. Open Items / Assumptions to Confirm

- Western vs. Eastern Arabic numerals.
- Final launcher icon and logo.
- Exact illustration set and who draws it.
- Default snooze duration (assumed 10 minutes).
- Whether caregivers get a distinct view in the first version.
