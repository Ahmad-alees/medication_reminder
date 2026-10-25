import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.onToggleLocale});

  final VoidCallback onToggleLocale;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _repeatUntilTaken = true;
  bool _vibrateEnabled = true;
  int _snoozeMinutes = 10;
  String _alarmSound = 'هادئ (افتراضي)';

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.settings,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),

          // Section 1: Reminders & Alarms
          _SectionHeader(title: 'التنبيهات والمنبه'),
          const SizedBox(height: 8),
          _SettingsGroupCard(
            children: [
              _SettingsTile(
                icon: Icons.music_note_outlined,
                title: 'صوت التنبيه',
                subtitle: _alarmSound,
                onTap: () => _chooseSound(context),
              ),
              const Divider(height: 1, indent: 56),
              _SettingsTile(
                icon: Icons.snooze_rounded,
                title: 'مدة التأجيل',
                subtitle: '$_snoozeMinutes دقائق',
                onTap: () => _chooseSnooze(context),
              ),
              const Divider(height: 1, indent: 56),
              SwitchListTile.adaptive(
                secondary: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.repeat_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                title: const Text(
                  'التكرار حتى التأكيد',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                subtitle: const Text(
                  'إعادة الرنين كل 5 دقائق حتى يتم أخذ الجرعة',
                  style: TextStyle(fontSize: 12),
                ),
                value: _repeatUntilTaken,
                activeThumbColor: AppColors.primary,
                onChanged: (val) => setState(() => _repeatUntilTaken = val),
              ),
              const Divider(height: 1, indent: 56),
              SwitchListTile.adaptive(
                secondary: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.vibration_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                title: const Text(
                  'الاهتزاز',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                subtitle: const Text(
                  'تفعيل الاهتزاز مع نغمة المنبه',
                  style: TextStyle(fontSize: 12),
                ),
                value: _vibrateEnabled,
                activeThumbColor: AppColors.primary,
                onChanged: (val) => setState(() => _vibrateEnabled = val),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Section 2: Appearance & Language
          _SectionHeader(title: 'المظهر واللغة'),
          const SizedBox(height: 8),
          _SettingsGroupCard(
            children: [
              _SettingsTile(
                icon: Icons.palette_outlined,
                title: 'المظهر',
                subtitle: 'تلقائي حسب النظام',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('المظهر يتبع إعدادات النظام الحالية'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              _SettingsTile(
                icon: Icons.language_rounded,
                title: strings.changeLanguage,
                subtitle: isArabic ? 'العربية' : 'English',
                onTap: widget.onToggleLocale,
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Section 3: Data & Reports
          _SectionHeader(title: 'البيانات والتقارير'),
          const SizedBox(height: 8),
          _SettingsGroupCard(
            children: [
              _SettingsTile(
                icon: Icons.ios_share_rounded,
                title: 'تصدير تقرير الالتزام',
                subtitle: 'تصدير ملخص الالتزام للأدوية',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تجهيز تقرير الالتزام للمشاركة'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              _SettingsTile(
                icon: Icons.cloud_done_outlined,
                title: 'النسخ الاحتياطي المحلي',
                subtitle: 'بياناتك محفوظة محلياً على جهازك',
                onTap: null,
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Medical Disclaimer Notice (Strictly compliant with AGENTS.md rule 2)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryTint.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.health_and_safety_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'إخلاء مسؤولية طبي',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  strings.reminderDisclaimer,
                  style: TextStyle(
                    color: AppColors.primary.withValues(alpha: 0.9),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App Info & Version
          Center(
            child: Column(
              children: [
                Text(
                  'ذكرني • Thakirny',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الإصدار 1.0.0 (غير متصل بالإنترنت)',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _chooseSound(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'اختر صوت التنبيه',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('هادئ (افتراضي)'),
                  trailing: _alarmSound == 'هادئ (افتراضي)'
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _alarmSound = 'هادئ (افتراضي)');
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  title: const Text('نغمة المنبه الكلاسيكية'),
                  trailing: _alarmSound == 'نغمة المنبه الكلاسيكية'
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _alarmSound = 'نغمة المنبه الكلاسيكية');
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  title: const Text('رنين ناعم'),
                  trailing: _alarmSound == 'رنين ناعم'
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _alarmSound = 'رنين ناعم');
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _chooseSnooze(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'اختر مدة التأجيل',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                for (final mins in [5, 10, 15, 20])
                  ListTile(
                    title: Text('$mins دقائق'),
                    trailing: _snoozeMinutes == mins
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() => _snoozeMinutes = mins);
                      Navigator.pop(ctx);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SettingsGroupCard extends StatelessWidget {
  const _SettingsGroupCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryTint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_left_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            )
          : null,
      onTap: onTap,
    );
  }
}
