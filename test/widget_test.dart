// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:medication_reminder/main.dart';

void main() {
  testWidgets('renders the Arabic home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('مرحبًا بك'), findsOneWidget);
    expect(find.text('جرعات اليوم'), findsOneWidget);
    expect(find.text('ميتفورمين'), findsOneWidget);
    expect(find.text('بانتظار'), findsOneWidget);
  });

  testWidgets('switches the home screen to English', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('تغيير اللغة'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text("Today's doses"), findsOneWidget);
    expect(find.text('Metformin'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
  });
}
