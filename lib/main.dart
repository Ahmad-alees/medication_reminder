import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:permission_handler/permission_handler.dart';

import 'data/local/app_database.dart';
import 'l10n/app_localizations.dart';

import 'app_theme.dart';
import 'data/dose_repository.dart';
import 'domain/models/dose_record.dart';
import 'domain/models/dose_status.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'features/alarm/alarm_screen.dart';
import 'features/medications/medication_detail_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/settings/settings_screen.dart';
import 'domain/rules/adherence.dart';
import 'scheduling/alarm_scheduler.dart';
import 'scheduling/android_alarm_scheduler.dart';
import 'scheduling/reminder_scheduler_service.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> handleNotificationResponse(
  NotificationResponse response,
  AppDatabase database,
  AlarmScheduler scheduler,
) async {
  final payload = response.payload;
  if (payload == null || !payload.contains('|')) return;

  final parts = payload.split('|');
  final reminderId = int.tryParse(parts[0]);
  final scheduledAtUtc = DateTime.tryParse(parts[1]);
  if (reminderId == null || scheduledAtUtc == null) return;

  final repository = DoseRepository(database: database, scheduler: scheduler);

  final dose =
      await repository.getDose(reminderId, scheduledAtUtc) ??
      DoseRecord(
        reminderId: reminderId,
        scheduledAtUtc: scheduledAtUtc,
        utcOffsetMinutes: DateTime.now().timeZoneOffset.inMinutes,
        status: DoseStatus.pending,
      );

  if (response.actionId == AndroidAlarmScheduler.actionTake) {
    await repository.take(dose);
    return;
  }

  if (response.actionId == AndroidAlarmScheduler.actionSnooze) {
    await repository.snooze(dose);
    return;
  }

  // Tapped notification body -> navigate to AlarmScreen
  final context = appNavigatorKey.currentContext;
  if (context != null) {
    final reminderRow = await (database.select(
      database.reminders,
    )..where((r) => r.id.equals(reminderId))).getSingleOrNull();
    final medRow = reminderRow != null
        ? await (database.select(database.medications)
                ..where((m) => m.id.equals(reminderRow.medicationId)))
              .getSingleOrNull()
        : null;

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => AlarmScreen(
            repository: repository,
            dose: dose,
            medicationName: medRow?.name ?? 'تذكير بالدواء',
            detail: medRow?.strength ?? medRow?.form ?? '',
            localTimeLabel: reminderRow?.localTime ?? '',
            showEscalation: dose.escalationSent,
          ),
        ),
      );
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  final alarmScheduler = AndroidAlarmScheduler();
  final schedulerService = ReminderSchedulerService(
    database: database,
    scheduler: alarmScheduler,
  );

  await alarmScheduler.initialize(
    onNotificationResponse: (response) =>
        handleNotificationResponse(response, database, alarmScheduler),
  );

  final launchDetails = await alarmScheduler.getLaunchDetails();
  if (launchDetails?.didNotificationLaunchApp ?? false) {
    final response = launchDetails?.notificationResponse;
    if (response != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleNotificationResponse(response, database, alarmScheduler);
      });
    }
  }

  // Reschedule future rolling window alarms on startup
  unawaited(schedulerService.rescheduleAll());

  runApp(
    MyApp(
      database: database,
      scheduler: alarmScheduler,
      schedulerService: schedulerService,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.database,
    this.scheduler,
    this.schedulerService,
  });

  final AppDatabase? database;
  final AlarmScheduler? scheduler;
  final ReminderSchedulerService? schedulerService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppDatabase _database;
  late final AlarmScheduler _scheduler;
  ReminderSchedulerService? _schedulerService;
  Locale _locale = const Locale('ar');
  bool? _onboardingCompleted;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _database = widget.database ?? AppDatabase();
    _scheduler = widget.scheduler ?? const NoOpAlarmScheduler();
    _schedulerService =
        widget.schedulerService ??
        ReminderSchedulerService(database: _database, scheduler: _scheduler);
    _initializeApp();
  }

  void _initializeApp() {
    _splashTimer = Timer(const Duration(milliseconds: 4500), () async {
      final completed = await _database.isOnboardingCompleted();
      if (mounted) {
        setState(() => _onboardingCompleted = completed);
      }
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _database.close();
    super.dispose();
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'ar'
          ? const Locale('en')
          : const Locale('ar');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: _onboardingCompleted == null
          ? const SplashScreen()
          : _onboardingCompleted!
          ? HomeScreen(
              database: _database,
              onToggleLocale: _toggleLocale,
              schedulerService: _schedulerService,
              scheduler: _scheduler,
            )
          : OnboardingScreen(onFinish: _openPermissions),
    );
  }

  void _openPermissions(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PermissionFlowScreen(onFinish: _completeOnboarding),
      ),
    );
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    await _database.markOnboardingCompleted();
    if (mounted) {
      setState(() => _onboardingCompleted = true);
    }
    if (context.mounted) {
      _openHome(context);
    }
  }

  void _openHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(
          database: _database,
          onToggleLocale: _toggleLocale,
          schedulerService: _schedulerService,
          scheduler: _scheduler,
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                image: true,
                label: strings.appLogoDescription,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 140,
                  height: 140,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                strings.welcomeTitle,
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                strings.welcomeTagline,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onContinue});

  final ValueChanged<BuildContext> onContinue;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final logoSize = (constraints.maxWidth * 0.34).clamp(112.0, 150.0);

            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  Semantics(
                    image: true,
                    label: strings.appLogoDescription,
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    strings.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      strings.welcomeTagline,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  const Spacer(flex: 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => onContinue(context),
                      child: Text(strings.welcomeContinue),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinish});

  final ValueChanged<BuildContext> onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final pages = [
      (
        asset: 'assets/images/onboarding_done.svg',
        title: strings.onboardingStepOneTitle,
        body: strings.onboardingStepOneBody,
        description: strings.onboardingOneImageDescription,
      ),
      (
        asset: 'assets/images/onboarding_time.svg',
        title: strings.onboardingStepTwoTitle,
        body: strings.onboardingStepTwoBody,
        description: strings.onboardingTwoImageDescription,
      ),
      (
        asset: 'assets/images/onboarding_medication.svg',
        title: strings.onboardingStepThreeTitle,
        body: strings.onboardingStepThreeBody,
        description: strings.onboardingThreeImageDescription,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      IconButton(
                        tooltip: strings.onboardingBack,
                        onPressed: () => _goToPage(_currentPage - 1),
                        icon: const Icon(Icons.arrow_back_rounded),
                      )
                    else
                      const SizedBox(width: 48),
                    const Spacer(),
                    TextButton(
                      onPressed: () => widget.onFinish(context),
                      child: Text(strings.onboardingSkip),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: pages.length,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return _OnboardingPageContent(
                      asset: page.asset,
                      title: page.title,
                      body: page.body,
                      imageDescription: page.description,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _OnboardingProgress(
                currentPage: _currentPage,
                steps: [
                  strings.onboardingStepOne,
                  strings.onboardingStepTwo,
                  strings.onboardingStepThree,
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == pages.length - 1) {
                      widget.onFinish(context);
                    } else {
                      _goToPage(_currentPage + 1);
                    }
                  },
                  child: Text(
                    _currentPage == pages.length - 1
                        ? strings.onboardingStart
                        : strings.onboardingNext,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageContent extends StatelessWidget {
  const _OnboardingPageContent({
    required this.asset,
    required this.title,
    required this.body,
    required this.imageDescription,
  });

  final String asset;
  final String title;
  final String body;
  final String imageDescription;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  image: true,
                  label: imageDescription,
                  child: SvgPicture.asset(
                    asset,
                    width: 240,
                    height: 240,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Text(
                    body,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingProgress extends StatelessWidget {
  const _OnboardingProgress({required this.currentPage, required this.steps});

  final int currentPage;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: steps[currentPage],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var index = 0; index < steps.length; index++) ...[
            if (index > 0) const SizedBox(width: 10),
            Semantics(
              label: steps[index],
              selected: index == currentPage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: index == currentPage ? 64 : 18,
                height: 18,
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? AppColors.primary
                      : AppColors.outline,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyTodayState extends StatelessWidget {
  const _EmptyTodayState({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAdd,
  });

  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                body,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LowStockCard extends StatelessWidget {
  const _LowStockCard({required this.title, required this.body, this.onTap});

  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningBackground = isDark
        ? AppColors.warningBackgroundDark
        : AppColors.warningBackground;
    final warningText = isDark
        ? AppColors.warningTextDark
        : AppColors.warningText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: warningBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.inventory_2_outlined, color: warningText),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: warningText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: warningText),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_left_rounded, color: warningText),
          ],
        ),
      ),
    );
  }
}

class _DoseSectionHeader extends StatelessWidget {
  const _DoseSectionHeader({
    required this.title,
    required this.count,
    required this.icon,
  });

  final String title;
  final String count;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(width: 8),
          Text(count, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class PermissionFlowScreen extends StatefulWidget {
  const PermissionFlowScreen({super.key, required this.onFinish});

  final ValueChanged<BuildContext> onFinish;

  @override
  State<PermissionFlowScreen> createState() => _PermissionFlowScreenState();
}

class _PermissionFlowScreenState extends State<PermissionFlowScreen> {
  int _currentStep = 0;

  void _move(int step) {
    setState(() => _currentStep = step);
  }

  Future<void> _requestCurrentPermission() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return;
    }
    try {
      if (_currentStep == 0) {
        await Permission.notification.request();
        await openAppSettings();
      } else if (_currentStep == 1) {
        await Permission.scheduleExactAlarm.request();
        await openAppSettings();
      } else if (_currentStep == 2) {
        final status = await Permission.ignoreBatteryOptimizations.request();
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
    } catch (_) {
      // Continue gracefully on desktop/unsupported environments
    }
  }

  Future<void> _onAllow() async {
    await _requestCurrentPermission();
    if (!mounted) return;
    if (_currentStep == 2) {
      widget.onFinish(context);
    } else {
      _move(_currentStep + 1);
    }
  }

  void _onLater() {
    if (_currentStep == 2) {
      widget.onFinish(context);
    } else {
      _move(_currentStep + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final pages = [
      (
        icon: Icons.notifications_active_outlined,
        title: strings.notificationPermissionTitle,
        body: strings.notificationPermissionBody,
        note: strings.notificationPermissionNote,
        step: strings.permissionStepOne,
      ),
      (
        icon: Icons.alarm_on_outlined,
        title: strings.exactAlarmPermissionTitle,
        body: strings.exactAlarmPermissionBody,
        note: strings.exactAlarmPermissionNote,
        step: strings.permissionStepTwo,
      ),
      (
        icon: Icons.battery_saver_outlined,
        title: strings.batteryPermissionTitle,
        body: strings.batteryPermissionBody,
        note: strings.batteryPermissionNote,
        step: strings.permissionStepThree,
      ),
    ];
    final page = pages[_currentStep];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      IconButton(
                        tooltip: strings.permissionBack,
                        onPressed: () => _move(_currentStep - 1),
                        icon: const Icon(Icons.arrow_back_rounded),
                      )
                    else
                      const SizedBox(width: 48),
                    const Spacer(),
                    Text(
                      page.step,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 420),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Semantics(
                          image: true,
                          label: page.title,
                          child: Container(
                            width: 176,
                            height: 176,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryTint,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              page.icon,
                              size: 88,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 340),
                          child: Text(
                            page.body,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTint,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  page.note,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onAllow,
                  child: Text(strings.permissionAllow),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _onLater,
                  child: Text(strings.permissionLater),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatTimeArabic(String time24) {
  final parts = time24.split(':');
  if (parts.length != 2) return time24;
  int hour = int.tryParse(parts[0]) ?? 0;
  final minute = parts[1];
  final isPM = hour >= 12;
  int hour12 = hour % 12;
  if (hour12 == 0) hour12 = 12;
  return '$hour12:$minute ${isPM ? 'م' : 'ص'}';
}

IconData getFormIcon(String form) {
  switch (form.toLowerCase()) {
    case 'capsule':
    case 'كبسولة':
      return Icons.medication_liquid_rounded;
    case 'syrup':
    case 'شراب':
      return Icons.local_drink_rounded;
    case 'injection':
    case 'حقنة':
      return Icons.vaccines_rounded;
    case 'drops':
    case 'قطرة':
      return Icons.water_drop_rounded;
    default:
      return Icons.medication_rounded;
  }
}

class TimePickerBottomSheet extends StatefulWidget {
  const TimePickerBottomSheet({super.key, required this.initialTime});

  final String initialTime;

  static Future<String?> show(
    BuildContext context, {
    String initialTime = '08:00',
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TimePickerBottomSheet(initialTime: initialTime),
    );
  }

  @override
  State<TimePickerBottomSheet> createState() => _TimePickerBottomSheetState();
}

class _TimePickerBottomSheetState extends State<TimePickerBottomSheet> {
  late int _hour12;
  late int _minute;
  late bool _isPM;

  @override
  void initState() {
    super.initState();
    final parts = widget.initialTime.split(':');
    final hour24 = int.tryParse(parts.isNotEmpty ? parts[0] : '8') ?? 8;
    _minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    _isPM = hour24 >= 12;
    _hour12 = hour24 % 12;
    if (_hour12 == 0) _hour12 = 12;
  }

  void _incrementHour() {
    setState(() {
      _hour12 = _hour12 >= 12 ? 1 : _hour12 + 1;
    });
  }

  void _decrementHour() {
    setState(() {
      _hour12 = _hour12 <= 1 ? 12 : _hour12 - 1;
    });
  }

  void _incrementMinute() {
    setState(() {
      _minute = (_minute + 5) % 60;
    });
  }

  void _decrementMinute() {
    setState(() {
      _minute = (_minute - 5 + 60) % 60;
    });
  }

  String _to24HourString() {
    int hour24 = _hour12 % 12;
    if (_isPM) hour24 += 12;
    return '${hour24.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF1A2C3D)
        : AppColors.surface;
    final textColor = isDark ? const Color(0xFFF1F5F9) : AppColors.text;
    final outlineColor = isDark
        ? const Color(0xFF2A4054)
        : const Color(0xFFE2E8F0);
    final buttonBoxColor = isDark
        ? const Color(0xFF142433)
        : const Color(0xFFFFFFFF);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3B5266) : const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'إضافة وقت',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepperColumn(
                  value: '$_hour12',
                  onUp: _incrementHour,
                  onDown: _decrementHour,
                  textColor: textColor,
                  outlineColor: outlineColor,
                  buttonBoxColor: buttonBoxColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: 0.785398,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF75B9D1)
                                : const Color(0xFF5A7184),
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Transform.rotate(
                        angle: 0.785398,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF75B9D1)
                                : const Color(0xFF5A7184),
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStepperColumn(
                  value: _minute.toString().padLeft(2, '0'),
                  onUp: _incrementMinute,
                  onDown: _decrementMinute,
                  textColor: textColor,
                  outlineColor: outlineColor,
                  buttonBoxColor: buttonBoxColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Expanded(
                  child: _buildPeriodPill(
                    label: 'مساءً',
                    isSelected: _isPM,
                    onTap: () => setState(() => _isPM = true),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildPeriodPill(
                    label: 'صباحاً',
                    isSelected: !_isPM,
                    onTap: () => setState(() => _isPM = false),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFF75B9D1)
                    : const Color(0xFF24697F),
                foregroundColor: isDark
                    ? const Color(0xFF0F2432)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.of(context).pop(_to24HourString()),
              child: const Text(
                'تأكيد الوقت',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? const Color(0xFF75B9D1)
                    : const Color(0xFF24697F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperColumn({
    required String value,
    required VoidCallback onUp,
    required VoidCallback onDown,
    required Color textColor,
    required Color outlineColor,
    required Color buttonBoxColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onUp,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 76,
            height: 48,
            decoration: BoxDecoration(
              color: buttonBoxColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: outlineColor, width: 1.2),
            ),
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 30,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 80,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 54,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: onDown,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 76,
            height: 48,
            decoration: BoxDecoration(
              color: buttonBoxColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: outlineColor, width: 1.2),
            ),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 30,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final selectedBg = isDark
        ? const Color(0xFF1E3547)
        : const Color(0xFFE2F0F4);
    final unselectedBg = isDark ? const Color(0xFF142433) : Colors.white;
    final selectedBorder = isDark
        ? const Color(0xFF4C8DAB)
        : const Color(0xFF4C8DAB);
    final unselectedBorder = isDark
        ? const Color(0xFF2A3F53)
        : const Color(0xFFCBD5E1);
    final selectedText = isDark
        ? const Color(0xFF75B9D1)
        : const Color(0xFF1E5B6E);
    final unselectedText = isDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF334155);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? selectedBorder : unselectedBorder,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? selectedText : unselectedText,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_rounded, size: 20, color: selectedText),
            ],
          ],
        ),
      ),
    );
  }
}

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({
    super.key,
    required this.database,
    this.schedulerService,
  });

  final AppDatabase database;
  final ReminderSchedulerService? schedulerService;

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _nameController = TextEditingController();
  final _strengthController = TextEditingController();
  final _notesController = TextEditingController();
  int _step = 0;
  String _unit = 'مغ';
  String _form = 'tablet';
  final List<String> _localTimes = ['08:00'];
  bool _everyDay = true;
  final Set<int> _selectedDays = {1, 2, 3, 4, 5, 6, 7};
  int _quantity = 30;
  bool _lowStockAlert = true;
  int _threshold = 7;

  @override
  void dispose() {
    _nameController.dispose();
    _strengthController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final strings = S.of(context);
    if (_step == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.medicationNameRequired)));
      return;
    }
    if (_step == 1 && _localTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إضافة وقت تذكير واحد على الأقل')),
      );
      return;
    }
    if (_step == 2) {
      final strengthText = _strengthController.text.trim().isEmpty
          ? null
          : '${_strengthController.text.trim()} $_unit';
      final medicationId = await widget.database.addMedicationWithReminders(
        name: _nameController.text.trim(),
        strength: strengthText,
        form: _form,
        stockQuantity: _quantity,
        stockThreshold: _lowStockAlert ? _threshold : 0,
        localTimes: _localTimes,
        everyDay: _everyDay,
        activeDays: _everyDay ? 'all' : _selectedDays.join(','),
      );
      await widget.schedulerService?.scheduleForMedication(medicationId);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } else {
      setState(() => _step++);
    }
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final titles = [
      'الخطوة 1 من 3 · البيانات الأساسية',
      'الخطوة 2 من 3 · المواعيد والأيام',
      'الخطوة 3 من 3 · المخزون والمراجعة',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: strings.back,
          onPressed: _back,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(strings.addAppointmentTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      titles[_step],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: (_step + 1) / 3),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: _step == 0
                    ? _identityStep(context)
                    : _step == 1
                    ? _scheduleStep(context)
                    : _reviewStep(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(_step == 2 ? strings.save : strings.next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _identityStep(BuildContext context) {
    final strings = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: strings.medicationName,
            hintText: 'مثال: باراسيتامول أو ميتفورمين',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _strengthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: strings.strengthOptional,
                  hintText: 'مثال: 500',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _unit,
                  onChanged: (value) => setState(() => _unit = value ?? _unit),
                  items: const [
                    DropdownMenuItem(value: 'مغ', child: Text('مغ')),
                    DropdownMenuItem(value: 'وحدة', child: Text('وحدة')),
                    DropdownMenuItem(value: 'مل', child: Text('مل')),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          strings.dosageForm,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _formChoice(
              context,
              strings.tablet,
              'tablet',
              Icons.medication_rounded,
            ),
            _formChoice(
              context,
              strings.capsule,
              'capsule',
              Icons.medication_liquid_rounded,
            ),
            _formChoice(
              context,
              strings.syrup,
              'syrup',
              Icons.local_drink_rounded,
            ),
            _formChoice(
              context,
              strings.injection,
              'injection',
              Icons.vaccines_rounded,
            ),
            _formChoice(
              context,
              strings.drops,
              'drops',
              Icons.water_drop_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _formChoice(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isSelected = _form == value;
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? scheme.onPrimary : scheme.primary,
      ),
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _form = value),
    );
  }

  Widget _scheduleStep(BuildContext context) {
    final strings = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final outlineColor = isDark ? AppColors.darkOutline : AppColors.outline;
    final textColor = isDark ? AppColors.darkText : AppColors.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.reminderTimes,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < _localTimes.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: outlineColor, width: 1.2),
            ),
            child: Row(
              children: [
                if (_localTimes.length > 1)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                    ),
                    tooltip: 'حذف',
                    onPressed: () => setState(() => _localTimes.removeAt(i)),
                  )
                else
                  const IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: null,
                  ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    final picked = await TimePickerBottomSheet.show(
                      context,
                      initialTime: _localTimes[i],
                    );
                    if (picked != null && mounted) {
                      setState(() {
                        _localTimes[i] = picked;
                        _localTimes.sort();
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatTimeArabic(_localTimes[i]),
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.access_time_rounded,
                          color: isDark
                              ? AppColors.primaryDark
                              : AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              final picked = await TimePickerBottomSheet.show(context);
              if (picked != null && mounted) {
                setState(() {
                  if (!_localTimes.contains(picked)) {
                    _localTimes.add(picked);
                    _localTimes.sort();
                  }
                });
              }
            },
            icon: const Icon(Icons.add_rounded),
            label: Text(strings.addTime),
          ),
        ),
        const SizedBox(height: 28),
        Text(strings.days, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: outlineColor, width: 1.2),
          ),
          child: Material(
            color: Colors.transparent,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _everyDay,
              onChanged: (value) => setState(() => _everyDay = value),
              title: Text(strings.everyDay),
              subtitle: Text(strings.everyDayDescription),
            ),
          ),
        ),
      ],
    );
  }

  Widget _reviewStep(BuildContext context) {
    final strings = S.of(context);
    final timesFormatted = _localTimes.map(formatTimeArabic).join('، ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _reviewSection(context, strings.medicationName, _nameController.text),
        _reviewSection(
          context,
          strings.reminderTimes,
          '$timesFormatted · ${_everyDay ? strings.everyDay : 'أيام محددة'}',
        ),
        const SizedBox(height: 8),
        Text(
          strings.availableQuantity,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          strings.availableQuantityDescription,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              iconSize: 32,
              onPressed: () =>
                  setState(() => _quantity = _quantity > 0 ? _quantity - 1 : 0),
              icon: const Icon(Icons.remove_circle_outline_rounded),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$_quantity',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            IconButton(
              iconSize: 32,
              onPressed: () => setState(() => _quantity++),
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Material(
          color: Colors.transparent,
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _lowStockAlert,
            onChanged: (val) => setState(() => _lowStockAlert = val),
            title: Text(strings.lowStockAlert),
            subtitle: Text(strings.lowStockAlertDescription),
          ),
        ),
        if (_lowStockAlert) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${strings.alertThreshold}: '),
              IconButton(
                onPressed: () => setState(
                  () => _threshold = _threshold > 1 ? _threshold - 1 : 1,
                ),
                icon: const Icon(Icons.remove_rounded),
              ),
              Text(
                '$_threshold',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: () => setState(() => _threshold++),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: strings.notesOptional,
            hintText: 'مثال: بعد الأكل، أو مع كوب ماء وفير',
          ),
        ),
      ],
    );
  }

  Widget _reviewSection(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(value, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.successIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationListView extends StatefulWidget {
  const MedicationListView({
    super.key,
    required this.database,
    required this.onAddAppointment,
  });

  final AppDatabase database;
  final VoidCallback onAddAppointment;

  @override
  State<MedicationListView> createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final scheme = Theme.of(context).colorScheme;

    return StreamBuilder<List<Medication>>(
      stream: widget.database.watchMedications(),
      builder: (context, snapshot) {
        final allMedications = snapshot.data ?? [];
        final filtered = allMedications
            .where((m) => m.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

        if (allMedications.isEmpty) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    strings.medicationsTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.medication_outlined,
                          size: 64,
                          color: scheme.primary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'لا توجد أدوية بعد',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'أضف أول دواء لنبدأ معًا ومتابعة مواعيد جرعاتك بدقة',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: widget.onAddAppointment,
                            icon: const Icon(Icons.add_rounded),
                            label: Text(strings.addMedication),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        final lowStockMedications = allMedications
            .where((m) => m.stockQuantity <= m.stockThreshold)
            .toList();

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Text(
                  strings.medicationsTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    labelText: strings.searchMedication,
                  ),
                ),
              ),
            ),
            if (lowStockMedications.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: _LowStockCard(
                    title: strings.lowStockTitle,
                    body:
                        '${strings.lowStockBody} (${lowStockMedications.length})',
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '${strings.medicationCount}: ${filtered.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final medication = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MedicationCard(
                      name: medication.name,
                      strength: medication.strength ?? medication.form,
                      stock: medication.stockQuantity,
                      form: medication.form,
                      scheme: scheme,
                      lowStockLabel: strings.lowStockOnly,
                      remainingLabel: strings.remainingStock,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => MedicationDetailScreen(
                              database: widget.database,
                              medication: medication,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onAddAppointment,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(strings.addAppointment),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MedicationCard extends StatelessWidget {
  const _MedicationCard({
    required this.name,
    required this.strength,
    required this.stock,
    required this.form,
    required this.scheme,
    required this.lowStockLabel,
    required this.remainingLabel,
    this.onTap,
  });

  final String name;
  final String strength;
  final int stock;
  final String form;
  final ColorScheme scheme;
  final String lowStockLabel;
  final String remainingLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isLow = stock <= 7;
    final statusColor = isLow ? scheme.error : scheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: scheme.tertiary,
                  foregroundColor: scheme.primary,
                  child: Icon(getFormIcon(form)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        strength,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left_rounded),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (stock / 100).clamp(0.0, 1.0),
              backgroundColor: scheme.tertiary,
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
            const SizedBox(height: 6),
            Text(
              isLow ? '$lowStockLabel: $stock' : '$remainingLabel: $stock',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isLow ? scheme.error : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.database,
    required this.onToggleLocale,
    this.repository,
    this.schedulerService,
    this.scheduler,
  });

  final AppDatabase database;
  final VoidCallback onToggleLocale;
  final DoseRepository? repository;
  final ReminderSchedulerService? schedulerService;
  final AlarmScheduler? scheduler;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  int _selectedNavigation = 0;
  late final DoseRepository _repository;
  late Stream<List<TodayDose>> _dosesStream;

  @override
  void initState() {
    super.initState();
    _repository =
        widget.repository ??
        DoseRepository(
          database: widget.database,
          scheduler: widget.scheduler ?? const NoOpAlarmScheduler(),
        );
    _dosesStream = _repository.watchDosesForLocalDate(_selectedDate);
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository ||
        oldWidget.database != widget.database) {
      _repository =
          widget.repository ?? DoseRepository(database: widget.database);
      _dosesStream = _repository.watchDosesForLocalDate(_selectedDate);
    }
  }

  Future<void> _handleTake(DoseRecord dose) async {
    final strings = S.of(context);
    await _repository.take(dose);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.doseLoggedTitle),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleSnooze(DoseRecord dose) async {
    final strings = S.of(context);
    await _repository.snooze(dose);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${strings.snoozed}: 10 دقائق'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleSkip(DoseRecord dose) async {
    final strings = S.of(context);
    await _repository.skip(dose);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.missed),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _statusLabel(DoseStatus status, S strings) {
    switch (status) {
      case DoseStatus.pending:
        return strings.upcoming;
      case DoseStatus.taken:
        return strings.taken;
      case DoseStatus.snoozed:
        return strings.snoozed;
      case DoseStatus.missed:
        return strings.missed;
    }
  }

  Color _statusColor(DoseStatus status, ColorScheme scheme) {
    switch (status) {
      case DoseStatus.pending:
        return scheme.primary;
      case DoseStatus.taken:
        return AppColors.successIcon;
      case DoseStatus.snoozed:
        return AppColors.warningText;
      case DoseStatus.missed:
        return scheme.error;
    }
  }

  Color _statusBgColor(DoseStatus status, ColorScheme scheme) {
    switch (status) {
      case DoseStatus.pending:
        return AppColors.primaryTint;
      case DoseStatus.taken:
        return AppColors.successBackground;
      case DoseStatus.snoozed:
        return AppColors.warningBackground;
      case DoseStatus.missed:
        return AppColors.errorBackground;
    }
  }

  IconData _statusIcon(DoseStatus status) {
    switch (status) {
      case DoseStatus.pending:
        return Icons.schedule_rounded;
      case DoseStatus.taken:
        return Icons.check_circle_rounded;
      case DoseStatus.snoozed:
        return Icons.snooze_rounded;
      case DoseStatus.missed:
        return Icons.cancel_rounded;
    }
  }

  Future<void> _openAddAppointment() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => AddAppointmentScreen(
          database: widget.database,
          schedulerService: widget.schedulerService,
        ),
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).appointmentSaved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? strings.goodMorning
        : now.hour < 17
        ? strings.goodAfternoon
        : strings.goodEvening;
    final formattedDate = DateFormat(
      locale == 'ar' ? 'EEEE، d MMMM' : 'EEEE, MMMM d',
      locale,
    ).format(now);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _selectedNavigation == 1
            ? MedicationListView(
                database: widget.database,
                onAddAppointment: _openAddAppointment,
              )
            : _selectedNavigation == 2
            ? StreamBuilder<List<dynamic>>(
                stream: widget.database.select(widget.database.doses).watch(),
                builder: (context, snapshot) {
                  final rows = snapshot.data ?? [];
                  final doses = rows
                      .map((r) => doseRowToRecord(r as dynamic))
                      .toList();
                  final summary = summarizeAdherence(doses);
                  return ReportsScreen(summary: summary);
                },
              )
            : _selectedNavigation == 3
            ? SettingsScreen(onToggleLocale: widget.onToggleLocale)
            : StreamBuilder<List<TodayDose>>(
                stream: _dosesStream,
                builder: (context, snapshot) {
                  final doses = snapshot.data ?? [];
                  final hasReminders = doses.isNotEmpty;
                  final totalCount = doses.length;
                  final takenCount = doses
                      .where((d) => d.dose.status == DoseStatus.taken)
                      .length;
                  final nextPending = doses
                      .where(
                        (d) =>
                            d.dose.status == DoseStatus.pending ||
                            d.dose.status == DoseStatus.snoozed,
                      )
                      .firstOrNull;
                  final nextTime = nextPending != null
                      ? formatTimeArabic(nextPending.reminder.localTime)
                      : '--:--';

                  // Group doses by time of day
                  final morningDoses = doses.where((d) {
                    final h =
                        int.tryParse(d.reminder.localTime.split(':')[0]) ?? 0;
                    return h < 12;
                  }).toList();

                  final afternoonDoses = doses.where((d) {
                    final h =
                        int.tryParse(d.reminder.localTime.split(':')[0]) ?? 0;
                    return h >= 12 && h < 17;
                  }).toList();

                  final eveningDoses = doses.where((d) {
                    final h =
                        int.tryParse(d.reminder.localTime.split(':')[0]) ?? 0;
                    return h >= 17;
                  }).toList();

                  final hasLowStock = doses.any(
                    (d) =>
                        d.medication.stockQuantity <=
                        d.medication.stockThreshold,
                  );

                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greeting,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${strings.todayPrefix} $formattedDate',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: _WeekStrip(
                            selectedDate: _selectedDate,
                            onSelect: (date) => setState(() {
                              _selectedDate = date;
                              _dosesStream = _repository.watchDosesForLocalDate(
                                _selectedDate,
                              );
                            }),
                          ),
                        ),
                      ),
                      if (hasReminders) ...[
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          sliver: SliverToBoxAdapter(
                            child: _ProgressCard(
                              title: strings.dailyProgress,
                              completedLabel: strings.dailyProgressCount(
                                takenCount,
                                totalCount,
                              ),
                              nextLabel: strings.nextDose,
                              nextDose: nextTime,
                              primary: colors.primary,
                              ratio: '$takenCount/$totalCount',
                              progress: totalCount > 0
                                  ? takenCount / totalCount
                                  : 0.0,
                            ),
                          ),
                        ),
                        if (hasLowStock)
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            sliver: SliverToBoxAdapter(
                              child: _LowStockCard(
                                title: strings.lowStockTitle,
                                body: strings.lowStockBody,
                                onTap: () =>
                                    setState(() => _selectedNavigation = 1),
                              ),
                            ),
                          ),
                        if (morningDoses.isNotEmpty)
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                            sliver: SliverList.list(
                              children: [
                                _DoseSectionHeader(
                                  title: strings.morning,
                                  count: strings.dosesCount(
                                    morningDoses.length,
                                  ),
                                  icon: Icons.wb_sunny_outlined,
                                ),
                                for (final d in morningDoses) ...[
                                  _DoseTile(
                                    medication: d.medication.name,
                                    detail:
                                        d.medication.strength ??
                                        d.medication.form,
                                    time: formatTimeArabic(
                                      d.reminder.localTime,
                                    ),
                                    status: _statusLabel(
                                      d.dose.status,
                                      strings,
                                    ),
                                    statusColor: _statusColor(
                                      d.dose.status,
                                      colors,
                                    ),
                                    statusBackgroundColor: _statusBgColor(
                                      d.dose.status,
                                      colors,
                                    ),
                                    statusIcon: _statusIcon(d.dose.status),
                                    icon: getFormIcon(d.medication.form),
                                    isActionable:
                                        d.dose.status == DoseStatus.pending ||
                                        d.dose.status == DoseStatus.snoozed,
                                    onTake: () => _handleTake(d.dose),
                                    onSnooze: () => _handleSnooze(d.dose),
                                    onSkip: () => _handleSkip(d.dose),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            ),
                          ),
                        if (afternoonDoses.isNotEmpty)
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                            sliver: SliverList.list(
                              children: [
                                _DoseSectionHeader(
                                  title: strings.afternoon,
                                  count: strings.dosesCount(
                                    afternoonDoses.length,
                                  ),
                                  icon: Icons.wb_twilight_outlined,
                                ),
                                for (final d in afternoonDoses) ...[
                                  _DoseTile(
                                    medication: d.medication.name,
                                    detail:
                                        d.medication.strength ??
                                        d.medication.form,
                                    time: formatTimeArabic(
                                      d.reminder.localTime,
                                    ),
                                    status: _statusLabel(
                                      d.dose.status,
                                      strings,
                                    ),
                                    statusColor: _statusColor(
                                      d.dose.status,
                                      colors,
                                    ),
                                    statusBackgroundColor: _statusBgColor(
                                      d.dose.status,
                                      colors,
                                    ),
                                    statusIcon: _statusIcon(d.dose.status),
                                    icon: getFormIcon(d.medication.form),
                                    isActionable:
                                        d.dose.status == DoseStatus.pending ||
                                        d.dose.status == DoseStatus.snoozed,
                                    onTake: () => _handleTake(d.dose),
                                    onSnooze: () => _handleSnooze(d.dose),
                                    onSkip: () => _handleSkip(d.dose),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            ),
                          ),
                        if (eveningDoses.isNotEmpty)
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                            sliver: SliverList.list(
                              children: [
                                _DoseSectionHeader(
                                  title: strings.evening,
                                  count: strings.dosesCount(
                                    eveningDoses.length,
                                  ),
                                  icon: Icons.nightlight_outlined,
                                ),
                                for (final d in eveningDoses) ...[
                                  _DoseTile(
                                    medication: d.medication.name,
                                    detail:
                                        d.medication.strength ??
                                        d.medication.form,
                                    time: formatTimeArabic(
                                      d.reminder.localTime,
                                    ),
                                    status: _statusLabel(
                                      d.dose.status,
                                      strings,
                                    ),
                                    statusColor: _statusColor(
                                      d.dose.status,
                                      colors,
                                    ),
                                    statusBackgroundColor: _statusBgColor(
                                      d.dose.status,
                                      colors,
                                    ),
                                    statusIcon: _statusIcon(d.dose.status),
                                    icon: getFormIcon(d.medication.form),
                                    isActionable:
                                        d.dose.status == DoseStatus.pending ||
                                        d.dose.status == DoseStatus.snoozed,
                                    onTake: () => _handleTake(d.dose),
                                    onSnooze: () => _handleSnooze(d.dose),
                                    onSkip: () => _handleSkip(d.dose),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            ),
                          ),
                        const SliverToBoxAdapter(child: SizedBox(height: 96)),
                      ] else
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _EmptyTodayState(
                            title: strings.emptyTodayTitle,
                            body: strings.emptyTodayBody,
                            actionLabel: strings.addAppointment,
                            onAdd: _openAddAppointment,
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddAppointment,
        tooltip: strings.addAppointment,
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavigation,
        onDestinationSelected: (index) =>
            setState(() => _selectedNavigation = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today_rounded),
            label: strings.today,
          ),
          NavigationDestination(
            icon: const Icon(Icons.medication_outlined),
            selectedIcon: const Icon(Icons.medication_rounded),
            label: strings.medications,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insert_chart_outlined_rounded),
            selectedIcon: const Icon(Icons.insert_chart_rounded),
            label: strings.reports,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: strings.settings,
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.selectedDate, required this.onSelect});

  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  static const List<String> _arabicDays = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final today = DateUtils.dateOnly(DateTime.now());

    // Sunday of the current week (Sunday = index 0, Saturday = index 6)
    final daysFromSunday = today.weekday % 7;
    final sunday = today.subtract(Duration(days: daysFromSunday));
    final days = List<DateTime>.generate(
      7,
      (index) => sunday.add(Duration(days: index)),
    );

    return SizedBox(
      height: 88,
      child: Row(
        children: List.generate(7, (index) {
          final date = days[index];
          final isSelected = DateUtils.isSameDay(date, selectedDate);
          final isToday = DateUtils.isSameDay(date, today);
          final dayName = isArabic
              ? _arabicDays[index]
              : DateFormat('EEE').format(date);

          // Visual styling:
          // Selected: Solid primary
          // Today (not selected): Highlighted tint background + primary border + dot
          // Other: Neutral surface
          Color backgroundColor;
          Color borderColor;
          Color textColor;
          Color numberColor;

          if (isSelected) {
            backgroundColor = theme.colorScheme.primary;
            borderColor = theme.colorScheme.primary;
            textColor = Colors.white;
            numberColor = Colors.white;
          } else if (isToday) {
            backgroundColor = AppColors.primaryTint;
            borderColor = theme.colorScheme.primary;
            textColor = theme.colorScheme.primary;
            numberColor = theme.colorScheme.primary;
          } else {
            backgroundColor = theme.colorScheme.surface;
            borderColor = theme.colorScheme.outline.withValues(alpha: 0.5);
            textColor = theme.colorScheme.onSurfaceVariant;
            numberColor = theme.colorScheme.onSurface;
          }

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 3,
                right: index == 6 ? 0 : 3,
              ),
              child: Semantics(
                button: true,
                selected: isSelected,
                label: '$dayName ${date.day}${isToday ? ' (اليوم)' : ''}',
                child: GestureDetector(
                  onTap: () => onSelect(date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: borderColor,
                        width: (isSelected || isToday) ? 1.5 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 11,
                            fontWeight: (isSelected || isToday)
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            color: numberColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(height: 3),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.completedLabel,
    required this.nextLabel,
    required this.nextDose,
    required this.primary,
    this.ratio = '0/0',
    this.progress = 0.0,
  });

  final String title;
  final String completedLabel;
  final String nextLabel;
  final String nextDose;
  final Color primary;
  final String ratio;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1020475B),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(ratio, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: scheme.tertiary,
              valueColor: AlwaysStoppedAnimation(primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(completedLabel, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 18, color: primary),
              const SizedBox(width: 6),
              Text(nextLabel, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 4),
              Text(nextDose, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoseTile extends StatelessWidget {
  const _DoseTile({
    required this.medication,
    required this.detail,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.icon,
    this.statusIcon,
    this.statusBackgroundColor,
    this.onTake,
    this.onSnooze,
    this.onSkip,
    this.isActionable = false,
  });

  final String medication;
  final String detail;
  final String time;
  final String status;
  final Color statusColor;
  final IconData icon;
  final IconData? statusIcon;
  final Color? statusBackgroundColor;
  final VoidCallback? onTake;
  final VoidCallback? onSnooze;
  final VoidCallback? onSkip;
  final bool isActionable;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    if (detail.isNotEmpty)
                      Text(
                        detail,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          statusBackgroundColor ??
                          statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (statusIcon != null) ...[
                          Icon(statusIcon, size: 13, color: statusColor),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isActionable) ...[
            const SizedBox(height: 14),
            Divider(height: 1, color: scheme.outline.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: onTake,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: Text(
                        strings.takenAction,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.6),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: onSnooze,
                      icon: const Icon(Icons.snooze_rounded, size: 16),
                      label: const Text(
                        '10 د',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (status.contains('أخذ') ||
              status.contains('taken') ||
              status.contains('Taken')) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: Color(0xFF16A34A),
                ),
                const SizedBox(width: 6),
                Text(
                  'تم أخذ الجرعة بنجاح',
                  style: TextStyle(
                    color: const Color(0xFF16A34A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
