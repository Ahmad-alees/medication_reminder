// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medication_reminder/main.dart';

void main() {
  testWidgets('renders the Arabic welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ذكرني'), findsOneWidget);
    expect(find.text('نذكّرك، لتبقى بخير'), findsOneWidget);
    expect(find.text('اضغط للمتابعة'), findsOneWidget);

    await tester.tap(find.text('اضغط للمتابعة'));
    await tester.pumpAndSettle();

    expect(find.text('مرحبًا بك في ذكرني'), findsOneWidget);
    expect(find.bySemanticsLabel('الشاشة 1 من 3'), findsWidgets);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('تذكير في الوقت المناسب'), findsOneWidget);
    expect(find.bySemanticsLabel('الشاشة 2 من 3'), findsWidgets);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('تأكيد بلمسة واحدة'), findsOneWidget);
    expect(find.bySemanticsLabel('الشاشة 3 من 3'), findsWidgets);

    await tester.tap(find.text('لنبدأ'));
    await tester.pumpAndSettle();

    expect(find.text('السماح بالإشعارات'), findsOneWidget);
    expect(find.text('1 من 3'), findsOneWidget);
    await tester.tap(find.text('لاحقًا'));
    await tester.pumpAndSettle();
    expect(find.text('السماح بالتنبيهات الدقيقة'), findsOneWidget);
    expect(find.text('2 من 3'), findsOneWidget);
    await tester.tap(find.text('لاحقًا'));
    await tester.pumpAndSettle();
    expect(find.text('تجاهل تحسين البطارية'), findsOneWidget);
    expect(find.text('3 من 3'), findsOneWidget);
    await tester.tap(find.text('لاحقًا'));
    await tester.pumpAndSettle();

    expect(find.text('لا توجد مواعيد مضافة'), findsOneWidget);
    expect(find.text('إضافة موعد'), findsOneWidget);

    await tester.tap(find.text('إضافة موعد'));
    await tester.pumpAndSettle();
    expect(find.text('إضافة موعد'), findsOneWidget);
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
  });

  testWidgets('renders the today screen after permissions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('اضغط للمتابعة'));
    await tester.pumpAndSettle();
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
  });

  testWidgets('supports onboarding back and skip actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('اضغط للمتابعة'));
    await tester.pumpAndSettle();
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
  });
}
