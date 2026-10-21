import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.onToggleLocale});

  final VoidCallback onToggleLocale;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.settings,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            strings.settingsPlaceholder,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onToggleLocale,
              child: Text(strings.changeLanguage),
            ),
          ),
          const Spacer(),
          Text(
            strings.reminderDisclaimer,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
