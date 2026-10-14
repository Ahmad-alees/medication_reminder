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

  /// No description provided for @greeting.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا بك'**
  String get greeting;

  /// No description provided for @todayDate.
  ///
  /// In ar, this message translates to:
  /// **'اليوم، 12 أكتوبر'**
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

  /// No description provided for @medications.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية'**
  String get medications;

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
