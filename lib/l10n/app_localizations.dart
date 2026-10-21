import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @welcomeTitle.
  ///
  /// In ar, this message translates to:
  /// **'ذكرني'**
  String get welcomeTitle;

  /// No description provided for @welcomeTagline.
  ///
  /// In ar, this message translates to:
  /// **'نذكّرك، لتبقى بخير'**
  String get welcomeTagline;

  /// No description provided for @welcomeContinue.
  ///
  /// In ar, this message translates to:
  /// **'اضغط للمتابعة'**
  String get welcomeContinue;

  /// No description provided for @appLogoDescription.
  ///
  /// In ar, this message translates to:
  /// **'شعار تطبيق ذكرني'**
  String get appLogoDescription;

  /// No description provided for @onboardingSkip.
  ///
  /// In ar, this message translates to:
  /// **'تخطّي'**
  String get onboardingSkip;

  /// No description provided for @onboardingBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get onboardingBack;

  /// No description provided for @onboardingNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In ar, this message translates to:
  /// **'لنبدأ'**
  String get onboardingStart;

  /// No description provided for @medications.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية'**
  String get medications;

  /// No description provided for @onboardingStepOne.
  ///
  /// In ar, this message translates to:
  /// **'الشاشة 1 من 3'**
  String get onboardingStepOne;

  /// No description provided for @onboardingStepTwo.
  ///
  /// In ar, this message translates to:
  /// **'الشاشة 2 من 3'**
  String get onboardingStepTwo;

  /// No description provided for @onboardingStepThree.
  ///
  /// In ar, this message translates to:
  /// **'الشاشة 3 من 3'**
  String get onboardingStepThree;

  /// No description provided for @onboardingStepOneTitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا بك في ذكرني'**
  String get onboardingStepOneTitle;

  /// No description provided for @onboardingStepOneBody.
  ///
  /// In ar, this message translates to:
  /// **'نساعدك على تذكّر أدويتك في مواعيدها، بهدوء ودون تعقيد.'**
  String get onboardingStepOneBody;

  /// No description provided for @onboardingStepTwoTitle.
  ///
  /// In ar, this message translates to:
  /// **'تذكير في الوقت المناسب'**
  String get onboardingStepTwoTitle;

  /// No description provided for @onboardingStepTwoBody.
  ///
  /// In ar, this message translates to:
  /// **'يصلك تذكير واضح عند موعد كل جرعة، مع اسم الدواء والكمية.'**
  String get onboardingStepTwoBody;

  /// No description provided for @onboardingStepThreeTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد بلمسة واحدة'**
  String get onboardingStepThreeTitle;

  /// No description provided for @onboardingStepThreeBody.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الجرعة بلمسة، وتابع التزامك يومًا بيوم.'**
  String get onboardingStepThreeBody;

  /// No description provided for @onboardingOneImageDescription.
  ///
  /// In ar, this message translates to:
  /// **'رسم هاتف يعرض علامة تأكيد'**
  String get onboardingOneImageDescription;

  /// No description provided for @onboardingTwoImageDescription.
  ///
  /// In ar, this message translates to:
  /// **'رسم ساعة مع جرس تنبيه'**
  String get onboardingTwoImageDescription;

  /// No description provided for @onboardingThreeImageDescription.
  ///
  /// In ar, this message translates to:
  /// **'رسم علبة أدوية'**
  String get onboardingThreeImageDescription;

  /// No description provided for @permissionBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get permissionBack;

  /// No description provided for @permissionAllow.
  ///
  /// In ar, this message translates to:
  /// **'السماح'**
  String get permissionAllow;

  /// No description provided for @permissionLater.
  ///
  /// In ar, this message translates to:
  /// **'لاحقًا'**
  String get permissionLater;

  /// No description provided for @permissionStepOne.
  ///
  /// In ar, this message translates to:
  /// **'1 من 3'**
  String get permissionStepOne;

  /// No description provided for @permissionStepTwo.
  ///
  /// In ar, this message translates to:
  /// **'2 من 3'**
  String get permissionStepTwo;

  /// No description provided for @permissionStepThree.
  ///
  /// In ar, this message translates to:
  /// **'3 من 3'**
  String get permissionStepThree;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In ar, this message translates to:
  /// **'السماح بالإشعارات'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionBody.
  ///
  /// In ar, this message translates to:
  /// **'نحتاج إلى الإشعارات لنذكّرك بموعد كل جرعة، حتى عندما يكون التطبيق مغلقًا.'**
  String get notificationPermissionBody;

  /// No description provided for @notificationPermissionNote.
  ///
  /// In ar, this message translates to:
  /// **'لن نرسل إلا التذكيرات المتعلقة بأدويتك.'**
  String get notificationPermissionNote;

  /// No description provided for @exactAlarmPermissionTitle.
  ///
  /// In ar, this message translates to:
  /// **'السماح بالتنبيهات الدقيقة'**
  String get exactAlarmPermissionTitle;

  /// No description provided for @exactAlarmPermissionBody.
  ///
  /// In ar, this message translates to:
  /// **'حتى يصل التذكير في الدقيقة المحددة تمامًا، لا قبلها ولا بعدها.'**
  String get exactAlarmPermissionBody;

  /// No description provided for @exactAlarmPermissionNote.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك تغيير ذلك لاحقًا من إعدادات الهاتف.'**
  String get exactAlarmPermissionNote;

  /// No description provided for @batteryPermissionTitle.
  ///
  /// In ar, this message translates to:
  /// **'تجاهل تحسين البطارية'**
  String get batteryPermissionTitle;

  /// No description provided for @batteryPermissionBody.
  ///
  /// In ar, this message translates to:
  /// **'بعض الهواتف توقف التطبيقات لتوفير البطارية. السماح بذلك يضمن ألّا يفوتك أي تذكير.'**
  String get batteryPermissionBody;

  /// No description provided for @batteryPermissionNote.
  ///
  /// In ar, this message translates to:
  /// **'تأثير ذلك على البطارية بسيط جدًا.'**
  String get batteryPermissionNote;

  /// No description provided for @goodMorning.
  ///
  /// In ar, this message translates to:
  /// **'صباح الخير'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In ar, this message translates to:
  /// **'نهارك سعيد'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In ar, this message translates to:
  /// **'مساء الخير'**
  String get goodEvening;

  /// No description provided for @todayPrefix.
  ///
  /// In ar, this message translates to:
  /// **'اليوم،'**
  String get todayPrefix;

  /// No description provided for @greeting.
  ///
  /// In ar, this message translates to:
  /// **'مساء الخير'**
  String get greeting;

  /// No description provided for @todayDate.
  ///
  /// In ar, this message translates to:
  /// **'اليوم، السبت، 10 أكتوبر'**
  String get todayDate;

  /// No description provided for @changeLanguage.
  ///
  /// In ar, this message translates to:
  /// **'تغيير اللغة'**
  String get changeLanguage;

  /// No description provided for @dailyProgress.
  ///
  /// In ar, this message translates to:
  /// **'تقدم اليوم'**
  String get dailyProgress;

  /// No description provided for @completedDoses.
  ///
  /// In ar, this message translates to:
  /// **'تم أخذ جرعة واحدة من أصل 3'**
  String get completedDoses;

  /// No description provided for @nextDose.
  ///
  /// In ar, this message translates to:
  /// **'الجرعة القادمة:'**
  String get nextDose;

  /// No description provided for @nextDoseValue.
  ///
  /// In ar, this message translates to:
  /// **'1:00 م'**
  String get nextDoseValue;

  /// No description provided for @todayDoses.
  ///
  /// In ar, this message translates to:
  /// **'جرعات اليوم'**
  String get todayDoses;

  /// No description provided for @emptyTodayTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مواعيد مضافة'**
  String get emptyTodayTitle;

  /// No description provided for @emptyTodayBody.
  ///
  /// In ar, this message translates to:
  /// **'أضف موعدًا لدوائك حتى نذكّرك به في الوقت المناسب.'**
  String get emptyTodayBody;

  /// No description provided for @addAppointment.
  ///
  /// In ar, this message translates to:
  /// **'إضافة موعد'**
  String get addAppointment;

  /// No description provided for @medicationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'أدويتي'**
  String get medicationsTitle;

  /// No description provided for @searchMedication.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن دواء'**
  String get searchMedication;

  /// No description provided for @medicationCount.
  ///
  /// In ar, this message translates to:
  /// **'5 أدوية'**
  String get medicationCount;

  /// No description provided for @remainingStock.
  ///
  /// In ar, this message translates to:
  /// **'المتبقي'**
  String get remainingStock;

  /// No description provided for @lowStockOnly.
  ///
  /// In ar, this message translates to:
  /// **'بقي قليلًا'**
  String get lowStockOnly;

  /// No description provided for @threeTimesDaily.
  ///
  /// In ar, this message translates to:
  /// **'3 مرات يوميًا · كل يوم'**
  String get threeTimesDaily;

  /// No description provided for @onceDaily.
  ///
  /// In ar, this message translates to:
  /// **'مرة واحدة يوميًا · كل يوم'**
  String get onceDaily;

  /// No description provided for @addAppointmentTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة موعد'**
  String get addAppointmentTitle;

  /// No description provided for @addStepOne.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة 1 من 3 · الاسم والتركيز'**
  String get addStepOne;

  /// No description provided for @addStepTwo.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة 2 من 3 · المواعيد والأيام'**
  String get addStepTwo;

  /// No description provided for @addStepThree.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة 3 من 3 · المخزون والملاحظات'**
  String get addStepThree;

  /// No description provided for @medicationName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء'**
  String get medicationName;

  /// No description provided for @medicationNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: ميتفورمين'**
  String get medicationNameHint;

  /// No description provided for @medicationNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسم الدواء أولًا'**
  String get medicationNameRequired;

  /// No description provided for @strengthOptional.
  ///
  /// In ar, this message translates to:
  /// **'التركيز (اختياري)'**
  String get strengthOptional;

  /// No description provided for @strengthHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: 500'**
  String get strengthHint;

  /// No description provided for @strengthUnit.
  ///
  /// In ar, this message translates to:
  /// **'وحدة التركيز'**
  String get strengthUnit;

  /// No description provided for @dosageForm.
  ///
  /// In ar, this message translates to:
  /// **'شكل الدواء'**
  String get dosageForm;

  /// No description provided for @tablet.
  ///
  /// In ar, this message translates to:
  /// **'قرص'**
  String get tablet;

  /// No description provided for @capsule.
  ///
  /// In ar, this message translates to:
  /// **'كبسولة'**
  String get capsule;

  /// No description provided for @syrup.
  ///
  /// In ar, this message translates to:
  /// **'شراب'**
  String get syrup;

  /// No description provided for @injection.
  ///
  /// In ar, this message translates to:
  /// **'حقنة'**
  String get injection;

  /// No description provided for @drops.
  ///
  /// In ar, this message translates to:
  /// **'قطرة'**
  String get drops;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @reminderTimes.
  ///
  /// In ar, this message translates to:
  /// **'أوقات التذكير'**
  String get reminderTimes;

  /// No description provided for @addTime.
  ///
  /// In ar, this message translates to:
  /// **'إضافة وقت'**
  String get addTime;

  /// No description provided for @days.
  ///
  /// In ar, this message translates to:
  /// **'الأيام'**
  String get days;

  /// No description provided for @everyDay.
  ///
  /// In ar, this message translates to:
  /// **'كل يوم'**
  String get everyDay;

  /// No description provided for @everyDayDescription.
  ///
  /// In ar, this message translates to:
  /// **'يصلك التذكير طوال أيام الأسبوع'**
  String get everyDayDescription;

  /// No description provided for @review.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة'**
  String get review;

  /// No description provided for @availableQuantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية المتوفرة'**
  String get availableQuantity;

  /// No description provided for @availableQuantityDescription.
  ///
  /// In ar, this message translates to:
  /// **'عدد الأقراص أو الجرعات الموجودة لديك الآن'**
  String get availableQuantityDescription;

  /// No description provided for @lowStockAlert.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه انخفاض المخزون'**
  String get lowStockAlert;

  /// No description provided for @lowStockAlertDescription.
  ///
  /// In ar, this message translates to:
  /// **'نذكّرك عندما يقلّ المخزون'**
  String get lowStockAlertDescription;

  /// No description provided for @alertThreshold.
  ///
  /// In ar, this message translates to:
  /// **'نبّهني عندما يتبقى'**
  String get alertThreshold;

  /// No description provided for @notesOptional.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات (اختياري)'**
  String get notesOptional;

  /// No description provided for @notesHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: بعد الأكل'**
  String get notesHint;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @appointmentSaved.
  ///
  /// In ar, this message translates to:
  /// **'حُفظ الموعد بنجاح'**
  String get appointmentSaved;

  /// No description provided for @currentDose.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن: ميتفورمين 500 مغ'**
  String get currentDose;

  /// No description provided for @lowStockTitle.
  ///
  /// In ar, this message translates to:
  /// **'دواءان قاربا على النفاد'**
  String get lowStockTitle;

  /// No description provided for @lowStockBody.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لعرض الأدوية وتجديدها'**
  String get lowStockBody;

  /// No description provided for @morning.
  ///
  /// In ar, this message translates to:
  /// **'الصباح'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In ar, this message translates to:
  /// **'الظهر'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In ar, this message translates to:
  /// **'المساء'**
  String get evening;

  /// No description provided for @threeDoses.
  ///
  /// In ar, this message translates to:
  /// **'3 جرعات'**
  String get threeDoses;

  /// No description provided for @twoDoses.
  ///
  /// In ar, this message translates to:
  /// **'جرعتان'**
  String get twoDoses;

  /// No description provided for @upcoming.
  ///
  /// In ar, this message translates to:
  /// **'قادمة'**
  String get upcoming;

  /// No description provided for @dueNow.
  ///
  /// In ar, this message translates to:
  /// **'حان الموعد'**
  String get dueNow;

  /// No description provided for @snoozedUntil.
  ///
  /// In ar, this message translates to:
  /// **'مؤجلة حتى 1:10 م'**
  String get snoozedUntil;

  /// No description provided for @missed.
  ///
  /// In ar, this message translates to:
  /// **'فائتة'**
  String get missed;

  /// No description provided for @firstMedication.
  ///
  /// In ar, this message translates to:
  /// **'ميتفورمين'**
  String get firstMedication;

  /// No description provided for @firstMedicationDetail.
  ///
  /// In ar, this message translates to:
  /// **'500 مغ · بعد الطعام'**
  String get firstMedicationDetail;

  /// No description provided for @firstDoseTime.
  ///
  /// In ar, this message translates to:
  /// **'8:00 ص'**
  String get firstDoseTime;

  /// No description provided for @secondMedication.
  ///
  /// In ar, this message translates to:
  /// **'فيتامين د'**
  String get secondMedication;

  /// No description provided for @secondMedicationDetail.
  ///
  /// In ar, this message translates to:
  /// **'1000 وحدة · مع الطعام'**
  String get secondMedicationDetail;

  /// No description provided for @secondDoseTime.
  ///
  /// In ar, this message translates to:
  /// **'1:00 م'**
  String get secondDoseTime;

  /// No description provided for @pending.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار'**
  String get pending;

  /// No description provided for @taken.
  ///
  /// In ar, this message translates to:
  /// **'تم أخذها'**
  String get taken;

  /// No description provided for @snoozed.
  ///
  /// In ar, this message translates to:
  /// **'مؤجلة'**
  String get snoozed;

  /// No description provided for @takenAction.
  ///
  /// In ar, this message translates to:
  /// **'تم أخذ الدواء'**
  String get takenAction;

  /// No description provided for @snoozeAction.
  ///
  /// In ar, this message translates to:
  /// **'ذكّرني بعد 10 دقائق'**
  String get snoozeAction;

  /// No description provided for @skipAction.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get skipAction;

  /// No description provided for @doseLoggedTitle.
  ///
  /// In ar, this message translates to:
  /// **'أحسنت! سُجّلت الجرعة'**
  String get doseLoggedTitle;

  /// No description provided for @doseLoggedBody.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل هذه الجرعة. اتبع تعليمات طبيبك دائمًا.'**
  String get doseLoggedBody;

  /// No description provided for @nextDoseTimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'الجرعة القادمة'**
  String get nextDoseTimeLabel;

  /// No description provided for @noMoreDosesToday.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد جرعات متبقية اليوم'**
  String get noMoreDosesToday;

  /// No description provided for @escalationWarning.
  ///
  /// In ar, this message translates to:
  /// **'تأخير الجرعات أو نسيانها قد يؤثر على علاجك — اتبع تعليمات طبيبك.'**
  String get escalationWarning;

  /// No description provided for @reportsPlaceholder.
  ///
  /// In ar, this message translates to:
  /// **'تقارير الالتزام ستُعرض هنا من سجل الجرعات المحفوظ.'**
  String get reportsPlaceholder;

  /// No description provided for @settingsPlaceholder.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات المنبّه واللغة ستُضاف هنا.'**
  String get settingsPlaceholder;

  /// No description provided for @reminderDisclaimer.
  ///
  /// In ar, this message translates to:
  /// **'هذا التطبيق للتذكير فقط، ولا يقدّم نصيحة طبية.'**
  String get reminderDisclaimer;

  /// No description provided for @dosesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} جرعات'**
  String dosesCount(int count);

  /// No description provided for @dailyProgressCount.
  ///
  /// In ar, this message translates to:
  /// **'{taken} من {total} جرعات اليوم'**
  String dailyProgressCount(int taken, int total);

  /// No description provided for @addMedication.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دواء'**
  String get addMedication;

  /// No description provided for @addMedicationComingSoon.
  ///
  /// In ar, this message translates to:
  /// **'إضافة الدواء ستكون متاحة في الخطوة التالية'**
  String get addMedicationComingSoon;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @reports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @sunday.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In ar, this message translates to:
  /// **'الاثنين'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get saturday;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
