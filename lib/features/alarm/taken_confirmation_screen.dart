import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../l10n/app_localizations.dart';

class TakenConfirmationScreen extends StatelessWidget {
  const TakenConfirmationScreen({
    super.key,
    required this.medicationName,
    this.nextDoseLabel,
  });

  final String medicationName;
  final String? nextDoseLabel;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.check_circle_rounded,
                size: 96,
                color: AppColors.successIcon,
              ),
              const SizedBox(height: 20),
              Text(
                strings.doseLoggedTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                medicationName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                strings.doseLoggedBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                strings.nextDoseTimeLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                nextDoseLabel ?? strings.noMoreDosesToday,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(strings.today),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
