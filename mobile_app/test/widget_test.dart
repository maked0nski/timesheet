import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/src/app.dart';

void main() {
  testWidgets('Timesheet shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TimesheetApp()));
    expect(find.text('Табель'), findsOneWidget);
  });

  testWidgets('Statistics menu opens with options', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TimesheetApp()));
    await tester.tap(find.text('Статистика'));
    await tester.pumpAndSettle();

    expect(find.text('Статистика'), findsWidgets);
    expect(find.text('Гістограма'), findsOneWidget);
    expect(find.text('Лінійна діаграма'), findsOneWidget);
    expect(find.text('Кругова діаграма'), findsOneWidget);
  });
}
