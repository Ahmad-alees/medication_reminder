import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';

import 'app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar');

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
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: WelcomeScreen(onContinue: _openOnboarding),
    );
  }

  void _openOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => OnboardingScreen(onFinish: _openPermissions),
      ),
    );
  }

  void _openPermissions(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PermissionFlowScreen(onFinish: _openHome),
      ),
    );
  }

  void _openHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(onToggleLocale: _toggleLocale),
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
                  physics: const NeverScrollableScrollPhysics(),
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
  const _LowStockCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningBackground = isDark
        ? AppColors.warningBackgroundDark
        : AppColors.warningBackground;
    final warningText = isDark
        ? AppColors.warningTextDark
        : AppColors.warningText;

    return Container(
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
                            decoration: BoxDecoration(
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
                              Icon(
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
                  onPressed: () {
                    if (_currentStep == pages.length - 1) {
                      widget.onFinish(context);
                    } else {
                      _move(_currentStep + 1);
                    }
                  },
                  child: Text(strings.permissionAllow),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    if (_currentStep == pages.length - 1) {
                      widget.onFinish(context);
                    } else {
                      _move(_currentStep + 1);
                    }
                  },
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

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _nameController = TextEditingController();
  final _strengthController = TextEditingController();
  final _notesController = TextEditingController();
  int _step = 0;
  String _unit = 'mg';
  String _form = 'tablet';
  bool _everyDay = true;
  int _quantity = 30;
  final int _threshold = 7;

  @override
  void dispose() {
    _nameController.dispose();
    _strengthController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _next() {
    final strings = S.of(context);
    if (_step == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.medicationNameRequired)));
      return;
    }
    if (_step == 2) {
      Navigator.of(context).pop(true);
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
      strings.addStepOne,
      strings.addStepTwo,
      strings.addStepThree,
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
            hintText: strings.medicationNameHint,
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
                  hintText: strings.strengthHint,
                ),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: _unit,
              onChanged: (value) => setState(() => _unit = value ?? _unit),
              items: const [
                DropdownMenuItem(value: 'mg', child: Text('mg')),
                DropdownMenuItem(value: 'unit', child: Text('unit')),
                DropdownMenuItem(value: 'ml', child: Text('ml')),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          strings.dosageForm,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        _formChoice(context, strings.tablet, 'tablet'),
        _formChoice(context, strings.capsule, 'capsule'),
        _formChoice(context, strings.syrup, 'syrup'),
        _formChoice(context, strings.injection, 'injection'),
        _formChoice(context, strings.drops, 'drops'),
      ],
    );
  }

  Widget _formChoice(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _form == value,
        onSelected: (_) => setState(() => _form = value),
      ),
    );
  }

  Widget _scheduleStep(BuildContext context) {
    final strings = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.reminderTimes,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.schedule_rounded),
          title: const Text('8:00 ص'),
          trailing: IconButton(
            tooltip: strings.back,
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded),
          label: Text(strings.addTime),
        ),
        const SizedBox(height: 28),
        Text(strings.days, style: Theme.of(context).textTheme.titleMedium),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _everyDay,
          onChanged: (value) => setState(() => _everyDay = value),
          title: Text(strings.everyDay),
          subtitle: Text(strings.everyDayDescription),
        ),
      ],
    );
  }

  Widget _reviewStep(BuildContext context) {
    final strings = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _reviewSection(context, strings.medicationName, _nameController.text),
        _reviewSection(
          context,
          strings.reminderTimes,
          '8:00 ص · ${strings.everyDay}',
        ),
        Text(
          strings.availableQuantity,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          strings.availableQuantityDescription,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _quantity++),
              icon: const Icon(Icons.add_circle_outline),
            ),
            Text('$_quantity', style: Theme.of(context).textTheme.titleLarge),
            IconButton(
              onPressed: () =>
                  setState(() => _quantity = _quantity > 0 ? _quantity - 1 : 0),
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ],
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: true,
          onChanged: (_) {},
          title: Text(strings.lowStockAlert),
          subtitle: Text(strings.lowStockAlertDescription),
        ),
        Text('${strings.alertThreshold}: $_threshold'),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: strings.notesOptional,
            hintText: strings.notesHint,
          ),
        ),
      ],
    );
  }

  Widget _reviewSection(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.check_circle_outline),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onToggleLocale});

  final VoidCallback onToggleLocale;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  int _selectedNavigation = 0;
  bool _hasAppointments = false;

  Future<void> _openAddAppointment() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const AddAppointmentScreen()),
    );
    if (saved == true && mounted) {
      setState(() => _hasAppointments = true);
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
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.headlineMedium,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: _WeekStrip(
                  selectedDate: _selectedDate,
                  onSelect: (date) => setState(() => _selectedDate = date),
                ),
              ),
            ),
            if (_hasAppointments) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _ProgressCard(
                    title: strings.dailyProgress,
                    completedLabel: strings.completedDoses,
                    nextLabel: strings.nextDose,
                    nextDose: strings.nextDoseValue,
                    primary: colors.primary,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _LowStockCard(
                    title: strings.lowStockTitle,
                    body: strings.lowStockBody,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                sliver: SliverList.list(
                  children: [
                    _DoseSectionHeader(
                      title: strings.morning,
                      count: strings.threeDoses,
                      icon: Icons.wb_sunny_outlined,
                    ),
                    _DoseTile(
                      medication: strings.firstMedication,
                      detail: strings.firstMedicationDetail,
                      time: strings.firstDoseTime,
                      status: strings.taken,
                      statusColor: AppColors.successStrong,
                      icon: Icons.medication_liquid_rounded,
                    ),
                    const SizedBox(height: 12),
                    _DoseTile(
                      medication: strings.secondMedication,
                      detail: strings.secondMedicationDetail,
                      time: strings.firstDoseTime,
                      status: strings.missed,
                      statusColor: AppColors.error,
                      icon: Icons.vaccines_outlined,
                    ),
                    const SizedBox(height: 20),
                    _DoseSectionHeader(
                      title: strings.afternoon,
                      count: strings.twoDoses,
                      icon: Icons.wb_twilight_outlined,
                    ),
                    _DoseTile(
                      medication: strings.firstMedication,
                      detail: strings.firstMedicationDetail,
                      time: strings.secondDoseTime,
                      status: strings.dueNow,
                      statusColor: colors.primary,
                      icon: Icons.medication_liquid_rounded,
                    ),
                    const SizedBox(height: 12),
                    _DoseTile(
                      medication: strings.secondMedication,
                      detail: strings.secondMedicationDetail,
                      time: strings.secondDoseTime,
                      status: strings.snoozedUntil,
                      statusColor: AppColors.warningText,
                      icon: Icons.vaccines_outlined,
                    ),
                    const SizedBox(height: 20),
                    _DoseSectionHeader(
                      title: strings.evening,
                      count: strings.twoDoses,
                      icon: Icons.nightlight_outlined,
                    ),
                    _DoseTile(
                      medication: strings.firstMedication,
                      detail: strings.firstMedicationDetail,
                      time: strings.nextDoseValue,
                      status: strings.upcoming,
                      statusColor: colors.primary,
                      icon: Icons.medication_liquid_rounded,
                    ),
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
        ),
      ),
      floatingActionButton: _hasAppointments
          ? FloatingActionButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(strings.addMedicationComingSoon)),
              ),
              tooltip: strings.addAppointment,
              child: const Icon(Icons.add_rounded),
            )
          : null,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final today = DateUtils.dateOnly(DateTime.now());
    final days = List<DateTime>.generate(
      6,
      (index) => today.add(Duration(days: index)),
    );

    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = days[index];
          final selected = DateUtils.isSameDay(date, selectedDate);
          final dayName = DateFormat('EEE', locale).format(date);
          return Semantics(
            button: true,
            selected: selected,
            label: '$dayName ${date.day}',
            child: GestureDetector(
              onTap: () => onSelect(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
  });

  final String title;
  final String completedLabel;
  final String nextLabel;
  final String nextDose;
  final Color primary;

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
              Text('1/3', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.33,
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
  });

  final String medication;
  final String detail;
  final String time;
  final String status;
  final Color statusColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: scheme.tertiary,
            foregroundColor: scheme.primary,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(detail, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
