// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SAr extends S {
  SAr([String locale = 'ar']) : super(locale);

  @override
  String get greeting => 'مرحبًا بك';

  @override
  String get todayDate => 'اليوم، 12 أكتوبر';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get dailyProgress => 'تقدم اليوم';

  @override
  String get completedDoses => 'تم أخذ جرعة واحدة من أصل 3';

  @override
  String get nextDose => 'الجرعة القادمة:';

  @override
  String get nextDoseValue => '1:00 م';

  @override
  String get todayDoses => 'جرعات اليوم';

  @override
  String get firstMedication => 'ميتفورمين';

  @override
  String get firstMedicationDetail => '500 مغ · بعد الطعام';

  @override
  String get firstDoseTime => '8:00 ص';

  @override
  String get secondMedication => 'فيتامين د';

  @override
  String get secondMedicationDetail => '1000 وحدة · مع الطعام';

  @override
  String get secondDoseTime => '1:00 م';

  @override
  String get pending => 'بانتظار';

  @override
  String get taken => 'تم أخذها';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get addMedicationComingSoon =>
      'إضافة الدواء ستكون متاحة في الخطوة التالية';

  @override
  String get today => 'اليوم';

  @override
  String get medications => 'الأدوية';

  @override
  String get reports => 'التقارير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get sunday => 'الأحد';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';
}
