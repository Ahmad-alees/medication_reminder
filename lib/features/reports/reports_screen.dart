import 'package:flutter/material.dart';

import '../../domain/rules/adherence.dart';
import '../../l10n/app_localizations.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key, required this.summary});

  final AdherenceSummary summary;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final percent = (summary.rate * 100).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.reports,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            strings.reportsPlaceholder,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text(
            '$percent%',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 12),
          Text('${strings.taken}: ${summary.taken}'),
          Text('${strings.missed}: ${summary.missed}'),
          Text('${strings.snoozed}: ${summary.snoozed}'),
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
