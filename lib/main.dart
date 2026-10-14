import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        builder: (_) => OnboardingScreen(onFinish: _openHome),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onToggleLocale});

  final VoidCallback onToggleLocale;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDay = 0;
  int _selectedNavigation = 0;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.lime,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.greeting,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            strings.todayDate,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: strings.changeLanguage,
                      onPressed: widget.onToggleLocale,
                      icon: const Icon(Icons.language_rounded),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: _WeekStrip(
                  selectedDay: _selectedDay,
                  onSelect: (day) => setState(() => _selectedDay = day),
                ),
              ),
            ),
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Text(
                  strings.todayDoses,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.list(
                children: [
                  _DoseTile(
                    medication: strings.firstMedication,
                    detail: strings.firstMedicationDetail,
                    time: strings.firstDoseTime,
                    status: strings.pending,
                    statusColor: colors.primary,
                    icon: Icons.medication_liquid_rounded,
                  ),
                  const SizedBox(height: 12),
                  _DoseTile(
                    medication: strings.secondMedication,
                    detail: strings.secondMedicationDetail,
                    time: strings.secondDoseTime,
                    status: strings.taken,
                    statusColor: AppColors.successStrong,
                    icon: Icons.vaccines_outlined,
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.addMedicationComingSoon)),
        ),
        tooltip: strings.addMedication,
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
  const _WeekStrip({required this.selectedDay, required this.onSelect});

  final int selectedDay;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    final days = [
      strings.sunday,
      strings.monday,
      strings.tuesday,
      strings.wednesday,
      strings.thursday,
      strings.friday,
      strings.saturday,
    ];

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == selectedDay;
          return Semantics(
            button: true,
            selected: selected,
            label: days[index],
            child: GestureDetector(
              onTap: () => onSelect(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 54,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? primary : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? primary : const Color(0xFFD5DDE3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      days[index].substring(0, 1),
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${index + 12}',
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
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
              backgroundColor: const Color(0xFFDCEBF1),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD5DDE3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFDCEBF1),
            foregroundColor: AppColors.teal,
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
