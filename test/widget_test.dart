// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medication_reminder/data/local/app_database.dart';
import 'package:medication_reminder/main.dart';

/// Helper: pump the splash timer and settle into onboarding.
Future<void> _advancePastSplash(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 4600));
  await tester.pumpAndSettle();
}

/// Helper: unmount the app tree and flush Drift's zero-duration stream cancellation timers.
Future<void> _teardownApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 10));
}

void main() {
  testWidgets('renders the Arabic welcome screen and auto-navigates', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(database: AppDatabase.forTesting()));
    await tester.pump();

    expect(find.text('ذكرني'), findsOneWidget);
    expect(find.text('نذكّرك، لتبقى بخير'), findsOneWidget);

    await _advancePastSplash(tester);

    expect(find.text('مرحبًا بك في ذكرني'), findsOneWidget);
    expect(find.bySemanticsLabel('الشاشة 1 من 3'), findsWidgets);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('تذكير في الوقت المناسب'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('تأكيد بلمسة واحدة'), findsOneWidget);

    await tester.tap(find.text('لنبدأ'));
    await tester.pumpAndSettle();

    expect(find.text('السماح بالإشعارات'), findsOneWidget);
    expect(find.text('1 من 3'), findsOneWidget);
    await tester.tap(find.text('لاحقًا'));
    await tester.pumpAndSettle();
    expect(find.text('السماح بالتنبيهات الدقيقة'), findsOneWidget);
    await tester.tap(find.text('لاحقًا'));
    await tester.pumpAndSettle();
    expect(find.text('تجاهل تحسين البطارية'), findsOneWidget);
    await tester.tap(find.text('لاحقًا'));
    await tester.pumpAndSettle();

    expect(find.text('لا توجد مواعيد مضافة'), findsOneWidget);
    expect(find.text('إضافة موعد'), findsOneWidget);

    await tester.tap(find.text('إضافة موعد'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'دواء تجريبي');
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('أوقات التذكير'), findsOneWidget);
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('الكمية المتوفرة'), findsOneWidget);
    await tester.tap(find.text('حفظ'));
    await tester.pumpAndSettle();
    expect(find.text('الصباح'), findsOneWidget);
    await _teardownApp(tester);
  });

  testWidgets('renders the today screen after permissions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(database: AppDatabase.forTesting()));
    await tester.pump();

    await _advancePastSplash(tester);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('لنبدأ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('السماح'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('السماح'));
    await tester.pumpAndSettle();
    expect(find.text('تجاهل تحسين البطارية'), findsOneWidget);
    await tester.tap(find.text('السماح'));
    await tester.pumpAndSettle();

    expect(find.text('لا توجد مواعيد مضافة'), findsOneWidget);
    expect(find.text('إضافة موعد'), findsOneWidget);
    await _teardownApp(tester);
  });

  testWidgets('supports onboarding back and skip actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(database: AppDatabase.forTesting()));
    await tester.pump();

    await _advancePastSplash(tester);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('رجوع'));
    await tester.pumpAndSettle();
    expect(find.text('مرحبًا بك في ذكرني'), findsOneWidget);

    await tester.tap(find.text('تخطّي'));
    await tester.pumpAndSettle();
    expect(find.text('السماح بالإشعارات'), findsOneWidget);
    await tester.tap(find.text('لاحقًا'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('لاحقًا'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('لاحقًا'));
    await tester.pumpAndSettle();
    await _teardownApp(tester);
  });
}
