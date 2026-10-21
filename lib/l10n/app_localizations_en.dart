// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTitle => 'Dhakkirni';

  @override
  String get welcomeTagline => 'We remind you, so you can stay well';

  @override
  String get welcomeContinue => 'Tap to continue';

  @override
  String get appLogoDescription => 'Dhakkirni app logo';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Let\'s start';

  @override
  String get medications => 'Medications';

  @override
  String get onboardingStepOne => 'Screen 1 of 3';

  @override
  String get onboardingStepTwo => 'Screen 2 of 3';

  @override
  String get onboardingStepThree => 'Screen 3 of 3';

  @override
  String get onboardingStepOneTitle => 'Welcome to Dhakkirni';

  @override
  String get onboardingStepOneBody =>
      'We help you remember your medications on time, calmly and simply.';

  @override
  String get onboardingStepTwoTitle => 'A reminder at the right time';

  @override
  String get onboardingStepTwoBody =>
      'You receive a clear reminder for each dose, with the medication name and amount.';

  @override
  String get onboardingStepThreeTitle => 'Confirm with one tap';

  @override
  String get onboardingStepThreeBody =>
      'Record a dose with one tap and follow your adherence day by day.';

  @override
  String get onboardingOneImageDescription =>
      'Illustration of a phone showing a check mark';

  @override
  String get onboardingTwoImageDescription =>
      'Illustration of a clock with a reminder bell';

  @override
  String get onboardingThreeImageDescription =>
      'Illustration of a medication box';

  @override
  String get permissionBack => 'Back';

  @override
  String get permissionAllow => 'Allow';

  @override
  String get permissionLater => 'Later';

  @override
  String get permissionStepOne => '1 of 3';

  @override
  String get permissionStepTwo => '2 of 3';

  @override
  String get permissionStepThree => '3 of 3';

  @override
  String get notificationPermissionTitle => 'Allow notifications';

  @override
  String get notificationPermissionBody =>
      'We need notifications to remind you when it is time for each dose, even when the app is closed.';

  @override
  String get notificationPermissionNote =>
      'We will only send reminders related to your medications.';

  @override
  String get exactAlarmPermissionTitle => 'Allow exact notifications';

  @override
  String get exactAlarmPermissionBody =>
      'So the reminder arrives at the exact minute, not before or after.';

  @override
  String get exactAlarmPermissionNote =>
      'You can change this later in your phone settings.';

  @override
  String get batteryPermissionTitle => 'Allow battery optimization exemption';

  @override
  String get batteryPermissionBody =>
      'Some phones stop apps to save battery. Allowing this helps prevent missed reminders.';

  @override
  String get batteryPermissionNote => 'The effect on battery life is minimal.';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get todayPrefix => 'Today,';

  @override
  String get greeting => 'Good evening';

  @override
  String get todayDate => 'Today, Saturday, October 10';

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
  String get emptyTodayTitle => 'No appointments added';

  @override
  String get emptyTodayBody =>
      'Add a medication time so we can remind you at the right moment.';

  @override
  String get addAppointment => 'Add appointment';

  @override
  String get medicationsTitle => 'My medications';

  @override
  String get searchMedication => 'Search medication';

  @override
  String get medicationCount => '5 medications';

  @override
  String get remainingStock => 'Remaining';

  @override
  String get lowStockOnly => 'Running low';

  @override
  String get threeTimesDaily => '3 times daily · Every day';

  @override
  String get onceDaily => 'Once daily · Every day';

  @override
  String get addAppointmentTitle => 'Add appointment';

  @override
  String get addStepOne => 'Step 1 of 3 · Name and strength';

  @override
  String get addStepTwo => 'Step 2 of 3 · Times and days';

  @override
  String get addStepThree => 'Step 3 of 3 · Stock and notes';

  @override
  String get medicationName => 'Medication name';

  @override
  String get medicationNameHint => 'Example: Metformin';

  @override
  String get medicationNameRequired => 'Enter the medication name first';

  @override
  String get strengthOptional => 'Strength (optional)';

  @override
  String get strengthHint => 'Example: 500';

  @override
  String get strengthUnit => 'Strength unit';

  @override
  String get dosageForm => 'Dosage form';

  @override
  String get tablet => 'Tablet';

  @override
  String get capsule => 'Capsule';

  @override
  String get syrup => 'Syrup';

  @override
  String get injection => 'Injection';

  @override
  String get drops => 'Drops';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get reminderTimes => 'Reminder times';

  @override
  String get addTime => 'Add time';

  @override
  String get days => 'Days';

  @override
  String get everyDay => 'Every day';

  @override
  String get everyDayDescription => 'You receive reminders throughout the week';

  @override
  String get review => 'Review';

  @override
  String get availableQuantity => 'Available quantity';

  @override
  String get availableQuantityDescription =>
      'Number of tablets or doses you have now';

  @override
  String get lowStockAlert => 'Low stock alert';

  @override
  String get lowStockAlertDescription => 'We remind you when stock is low';

  @override
  String get alertThreshold => 'Alert me when remaining';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get notesHint => 'Example: after food';

  @override
  String get save => 'Save';

  @override
  String get appointmentSaved => 'Appointment saved successfully';

  @override
  String get currentDose => 'Now: Metformin 500 mg';

  @override
  String get lowStockTitle => 'Two medications are running low';

  @override
  String get lowStockBody => 'Tap to view medications and refill';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get evening => 'Evening';

  @override
  String get threeDoses => '3 doses';

  @override
  String get twoDoses => '2 doses';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get dueNow => 'Due now';

  @override
  String get snoozedUntil => 'Snoozed until 1:10 PM';

  @override
  String get missed => 'Missed';

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
  String get snoozed => 'Snoozed';

  @override
  String get takenAction => 'Taken';

  @override
  String get snoozeAction => 'Remind me in 10 minutes';

  @override
  String get skipAction => 'Skip';

  @override
  String get doseLoggedTitle => 'Well done! The dose was logged';

  @override
  String get doseLoggedBody =>
      'This dose was recorded. Always follow your doctor\'s instructions.';

  @override
  String get nextDoseTimeLabel => 'Next dose';

  @override
  String get noMoreDosesToday => 'No remaining doses today';

  @override
  String get escalationWarning =>
      'Missing or delaying doses may affect your treatment — follow your doctor\'s instructions.';

  @override
  String get reportsPlaceholder =>
      'Adherence reports will appear here from the saved dose log.';

  @override
  String get settingsPlaceholder =>
      'Alarm and language settings will be added here.';

  @override
  String get reminderDisclaimer =>
      'This app is a reminder tool only. It does not give medical advice.';

  @override
  String dosesCount(int count) {
    return '$count doses';
  }

  @override
  String dailyProgressCount(int taken, int total) {
    return '$taken of $total doses today';
  }

  @override
  String get addMedication => 'Add medication';

  @override
  String get addMedicationComingSoon =>
      'Adding a medication will be available in the next step';

  @override
  String get today => 'Today';

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
