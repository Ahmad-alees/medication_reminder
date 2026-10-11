// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get greeting => 'Welcome back';

  @override
  String get todayDate => 'Today, October 12';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get dailyProgress => 'Today\'s progress';

  @override
  String get completedDoses => '1 of 3 doses taken';

  @override
  String get nextDose => 'Next dose:';

  @override
  String get nextDoseValue => '1:00 PM';

  @override
  String get todayDoses => 'Today\'s doses';

  @override
  String get firstMedication => 'Metformin';

  @override
  String get firstMedicationDetail => '500 mg · after food';

  @override
  String get firstDoseTime => '8:00 AM';

  @override
  String get secondMedication => 'Vitamin D';

  @override
  String get secondMedicationDetail => '1000 units · with food';

  @override
  String get secondDoseTime => '1:00 PM';

  @override
  String get pending => 'Pending';

  @override
  String get taken => 'Taken';

  @override
  String get addMedication => 'Add medication';

  @override
  String get addMedicationComingSoon =>
      'Adding a medication will be available in the next step';

  @override
  String get today => 'Today';

  @override
  String get medications => 'Medications';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get sunday => 'Sunday';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';
}
