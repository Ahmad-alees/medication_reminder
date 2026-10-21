import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../data/dose_repository.dart';
import '../../domain/models/dose_record.dart';
import '../../l10n/app_localizations.dart';
import 'taken_confirmation_screen.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({
    super.key,
    required this.repository,
    required this.dose,
    required this.medicationName,
    required this.detail,
    required this.localTimeLabel,
    this.showEscalation = false,
    this.nextDoseLabel,
  });

  final DoseRepository repository;
  final DoseRecord dose;
  final String medicationName;
  final String detail;
  final String localTimeLabel;
  final bool showEscalation;
  final String? nextDoseLabel;

  Future<void> _take(BuildContext context) async {
    await repository.take(dose);
    if (!context.mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => TakenConfirmationScreen(
          medicationName: medicationName,
          nextDoseLabel: nextDoseLabel,
        ),
      ),
    );
  }

  Future<void> _snooze(BuildContext context) async {
    await repository.snooze(dose);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _skip(BuildContext context) async {
    await repository.skip(dose);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Text(
                localTimeLabel,
                style: const TextStyle(
                  fontSize: 56,
                  height: 64 / 56,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication_rounded,
                  size: 72,
                  color: AppColors.onAccent,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                medicationName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  height: 32 / 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$detail · $localTimeLabel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
              if (showEscalation) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    strings.escalationWarning,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                  ),
                  onPressed: () => _take(context),
                  child: Text(strings.takenAction),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.white, width: 1.5),
                  ),
                  onPressed: () => _snooze(context),
                  child: Text(strings.snoozeAction),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _skip(context),
                child: Text(
                  strings.skipAction,
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
