# Spec: تطبيق ذكرني

- **Slug:** medication-reminders
- **Source intent:** intent/medication-reminders.md
- **Date:** 2026-10-10

## Acceptance criteria (Gherkin)

```gherkin
Feature: تذكير المريض بموعد تناول Medication

  Scenario: تشغيل Alarm عند حلول Reminder Time
    Given أن لدى المريض Reminder لدواء في وقت محدد وفي Active Days
    When يحين Reminder Time لذلك اليوم
    Then تضيء شاشة الهاتف على شاشة Alarm
    And يصدر Alarm
    And تظهر صورة معبّرة
    And تظهر أزرار تم التناول وتذكيري بعد 10 دقائق وتخطي

  Scenario: ظهور Alarm والهاتف مقفل
    Given أن الهاتف مقفل ولدى المريض Dose بانتظار موعدها
    When يحين Reminder Time
    Then تضيء شاشة الهاتف على شاشة Alarm
    And يصدر Alarm

  Scenario: تسجيل Dose كـ Taken
    Given أن شاشة Alarm ظاهرة لجرعة Dose
    When يختار المريض تم التناول
    Then تُسجّل الجرعة على أنها Taken
    And يتوقف Alarm المتكرر لهذه الجرعة
    And تظهر شاشة تؤكد تسجيل الجرعة
    And يظهر موعد الجرعة القادمة

  Scenario: تأجيل Alarm لمدة 10 دقائق
    Given أن شاشة Alarm ظاهرة لجرعة Dose
    When يختار المريض تذكيري بعد 10 دقائق
    Then يتوقف Alarm لهذه الجرعة مؤقتًا
    And يعود Alarm بعد 10 دقائق

  Scenario: عدم الاستجابة للتنبيه
    Given أن شاشة Alarm ظاهرة لجرعة Dose
    When لا يستجيب المريض لمدة 10 دقائق
    Then يتوقف Alarm مؤقتًا
    And يعود Alarm بعد 10 دقائق أخرى

  Scenario: استمرار التذكير حتى استجابة المريض
    Given أن المريض لم يستجب لـ Alarm سابق
    When يعود Alarm مرة أخرى
    And لا يختار المريض تم التناول أو تخطي
    Then يستمر التطبيق في إعادة Alarm وفق الفاصل المحدد

  Scenario: اختيار تخطي
    Given أن شاشة Alarm ظاهرة لجرعة Dose
    When يختار المريض تخطي
    Then تُسجّل الجرعة على أنها غير مأخوذة
    And يتوقف Alarm المتكرر لهذه الجرعة

  Scenario: العمل دون اتصال بالإنترنت
    Given أن الهاتف غير متصل بالإنترنت
    When يحين Reminder Time
    Then يعمل Alarm وتظهر شاشة التنبيه
    And يستطيع المريض اختيار الإجراء المناسب
    And لا يتوقف عمل التذكير بسبب عدم وجود الإنترنت

  Scenario: طلب الاتصال لرفع Usage Statistics
    Given أن التطبيق يعمل محليًا دون اتصال بالإنترنت
    And حان موعد المراجعة الأسبوعية أو كل أسبوعين
    When يحتاج التطبيق إلى رفع Usage Statistics
    Then يطلب من المريض تفعيل الإنترنت
    And لا يمنع الطلب عمل Alarm أو تسجيل Dose محليًا

  Scenario: استمرار التذكيرات بعد إعادة تشغيل الهاتف
    Given أن Reminder مفعّل وأن أذونات Alarm ما زالت مفعّلة
    When يعيد المريض تشغيل الهاتف
    Then يستمر التطبيق في آلية تشغيل التذكيرات
    And لا يطلب تفعيل الأذونات من جديد

  Scenario: التذكير مع تفعيل Battery Saver
    Given أن Reminder مفعّل وأن Battery Saver مفعّل
    When يحين Reminder Time
    Then يعمل Alarm وتظهر شاشة التنبيه
    And لا يتعطل التذكير بسبب Battery Saver

  Scenario: عرض العربية باتجاه RTL
    Given أن لغة التطبيق هي العربية
    When تظهر شاشة Alarm أو شاشة تسجيل Taken
    Then تظهر النصوص بالعربية
    And يكون اتجاه الواجهة RTL

  Scenario: عرض الإنجليزية باتجاه LTR
    Given أن لغة التطبيق هي الإنجليزية
    When تظهر شاشة Alarm أو شاشة تسجيل Taken
    Then تظهر النصوص بالإنجليزية
    And يكون اتجاه الواجهة LTR

  Scenario: ارتفاع Adherence كمؤشر نجاح
    Given أن Usage Statistics المرفوعة تتضمن نتائج متابعة الجرعات
    When تتم دراسة البيانات عبر فترة زمنية
    Then يمكن قياس Adherence للمريض
    And يكون نجاح التطبيق مرتبطًا بارتفاع نسبة التزام المريض بمواعيد Doses
```

## Derived edge cases (not stated by the author — confirm each)
- [ ] Time-zone change أثناء وجود Reminder مفعّل.
- [ ] تغيير ساعة الجهاز يدويًا.
- [ ] يوم DST.
- [ ] Reminder عند 23:59 أو 00:00.
- [ ] وجود Doses متعددة في الدقيقة نفسها.
- [ ] الضغط مرتين على تم التناول.
- [ ] تعديل أو حذف Reminder أثناء عمل Alarm.
- [ ] رفض أذونات Local Notification أو exact Alarm.
- [ ] إغلاق التطبيق بالكامل.
- [ ] اسم Medication طويل جدًا أو يحتوي على نص عربي وإنجليزي مختلط.
- [ ] السلوك عند انتهاء Battery Saver أو تغيّر قيود الشركة المصنّعة للجهاز.

## Out of scope
- تسجيل الدخول.
- إدارة أكثر من Patient في الحساب نفسه.
- تقديم نصائح طبية أو تشخيص أو توصيات دوائية.
- قاعدة بيانات خارجية للأدوية.

## Open questions
- ما Dose Status الذي يمثّل اختيار زر تخطي؟ المصطلحات المعتمدة حاليًا هي Pending وTaken وSnoozed وMissed.
- ما Usage Statistics التي تُرفع بالضبط، وما موافقة المريض المطلوبة قبل الرفع؟
- ما Backend المستخدم للمزامنة؟ القرار بين Firebase وSupabase لم يُحسم.
- ما النصوص العامة غير العلاجية المقبولة داخل شاشة Alarm؟
- ما آلية Android المطلوبة لضمان عمل Alarm مع Battery Saver، وما الأذونات اللازمة؟
- ما سلوك Reminder عند تغيير المنطقة الزمنية أو ساعة الجهاز؟
- هل يجب اعتماد الحالات المشتقة أعلاه ضمن النطاق؟

Status: approved
