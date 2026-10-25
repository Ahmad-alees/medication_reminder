import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medication_reminder/data/dose_repository.dart';
import 'package:medication_reminder/data/local/app_database.dart';
import 'package:medication_reminder/domain/models/dose_status.dart';
import 'package:medication_reminder/l10n/app_localizations.dart';
import 'package:medication_reminder/main.dart';

void main() {
  testWidgets('can mark dose as taken from home screen and decrements stock', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await db.addMedicationWithReminders(
      name: 'بنادول',
      strength: '500 مغ',
      form: 'tablet',
      stockQuantity: 10,
      stockThreshold: 3,
      localTimes: ['08:00'],
      everyDay: true,
      activeDays: 'all',
    );

    final repository = DoseRepository(database: db);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        home: Scaffold(
          body: HomeScreen(
            database: db,
            repository: repository,
            onToggleLocale: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('بنادول'), findsOneWidget);
    expect(find.text('تم أخذ الدواء'), findsOneWidget);

    await tester.ensureVisible(find.text('تم أخذ الدواء'));
    await tester.tap(find.text('تم أخذ الدواء'));
    await tester.pumpAndSettle();

    expect(find.text('تم أخذها'), findsOneWidget);

    final med = (await db.select(db.medications).get()).single;
    expect(med.stockQuantity, 9);

    final storedDoses = await db.select(db.doses).get();
    expect(storedDoses, hasLength(1));
    expect(storedDoses.single.status, DoseStatus.taken.storageValue);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  });

  testWidgets('can snooze dose from home screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.forTesting();
    addTearDown(db.close);

    await db.addMedicationWithReminders(
      name: 'أسبيرين',
      strength: '100 مغ',
      form: 'tablet',
      stockQuantity: 20,
      stockThreshold: 5,
      localTimes: ['09:00'],
      everyDay: true,
      activeDays: 'all',
    );

    final repository = DoseRepository(database: db);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        home: Scaffold(
          body: HomeScreen(
            database: db,
            repository: repository,
            onToggleLocale: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('أسبيرين'), findsOneWidget);
    expect(find.text('10 د'), findsOneWidget);

    await tester.ensureVisible(find.text('10 د'));
    await tester.tap(find.text('10 د'));
    await tester.pumpAndSettle();

    expect(find.text('مؤجلة'), findsOneWidget);

    final storedDoses = await db.select(db.doses).get();
    expect(storedDoses, hasLength(1));
    expect(storedDoses.single.status, DoseStatus.snoozed.storageValue);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
  });
}
