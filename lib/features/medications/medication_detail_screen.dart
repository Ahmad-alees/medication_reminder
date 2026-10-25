import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../core/format/time_format.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';

class MedicationDetailScreen extends StatefulWidget {
  const MedicationDetailScreen({
    super.key,
    required this.database,
    required this.medication,
  });

  final AppDatabase database;
  final Medication medication;

  @override
  State<MedicationDetailScreen> createState() => _MedicationDetailScreenState();
}

class _MedicationDetailScreenState extends State<MedicationDetailScreen> {
  late Medication _medication;
  List<Reminder> _reminders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _medication = widget.medication;
    _loadData();
  }

  Future<void> _loadData() async {
    final reminders = await widget.database.getRemindersForMedication(
      _medication.id,
    );
    final med = await (widget.database.select(
      widget.database.medications,
    )..where((row) => row.id.equals(_medication.id))).getSingleOrNull();

    if (mounted) {
      setState(() {
        if (med != null) _medication = med;
        _reminders = reminders;
        _loading = false;
      });
    }
  }

  IconData _getFormIcon(String form) {
    switch (form.toLowerCase()) {
      case 'capsule':
        return Icons.medication_liquid_rounded;
      case 'syrup':
        return Icons.water_drop_rounded;
      case 'injection':
        return Icons.vaccines_rounded;
      case 'drops':
        return Icons.opacity_rounded;
      default:
        return Icons.medication_rounded;
    }
  }

  Future<void> _openRefillSheet() async {
    final controller = TextEditingController(text: '30');
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('تجديد المخزون', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'أدخل الكمية التي ترغب في إضافتها إلى المخزون الحالي (${_medication.stockQuantity}):',
                style: Theme.of(ctx).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'الكمية الإضافية',
                  hintText: 'مثال: 30',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final qty = int.tryParse(controller.text.trim()) ?? 0;
                    if (qty > 0) {
                      Navigator.of(ctx).pop(qty);
                    }
                  },
                  child: const Text('إضافة للمخزون'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null && result > 0 && mounted) {
      await widget.database.refillStock(_medication.id, result);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تمت إضافة $result وحدة للمخزون بنجاح')),
        );
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text(
          'هل أنت متأكد من حذف هذا الدواء؟\nسيتم إيقاف جميع التنبيهات المستقبلية مع الاحتفاظ بسجل الجرعات السابقة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await widget.database.deleteMedication(_medication.id);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final strings = S.of(context);
    final isLowStock = _medication.stockQuantity <= _medication.stockThreshold;

    return Scaffold(
      appBar: AppBar(
        title: Text(_medication.name),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
            ),
            tooltip: 'حذف الدواء',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Main Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: scheme.outline),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: scheme.tertiary,
                          foregroundColor: scheme.primary,
                          child: Icon(_getFormIcon(_medication.form), size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _medication.name,
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _medication.strength ?? _medication.form,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stock Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isLowStock ? AppColors.error : scheme.outline,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'حالة المخزون',
                              style: theme.textTheme.titleMedium,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isLowStock
                                    ? AppColors.errorBackground
                                    : AppColors.successBackground,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                isLowStock ? 'منخفض' : 'متوفر',
                                style: TextStyle(
                                  color: isLowStock
                                      ? AppColors.error
                                      : AppColors.successIcon,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              '${_medication.stockQuantity}',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: isLowStock
                                    ? AppColors.error
                                    : scheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'وحدة متبقية',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'تنبيه عند الوصول إلى ${_medication.stockThreshold} وحدات فأقل',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _openRefillSheet,
                            icon: const Icon(Icons.add_circle_outline_rounded),
                            label: const Text('تجديد المخزون'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reminders Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: scheme.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.reminderTimes,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        if (_reminders.isEmpty)
                          Text(
                            'لا توجد مواعيد تذكير مسجلة',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          )
                        else
                          for (final r in _reminders) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: scheme.tertiary.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_filled_rounded,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        formatTimeArabic(r.localTime),
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    r.everyDay
                                        ? strings.everyDay
                                        : r.activeDays,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
