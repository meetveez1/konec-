import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hahahoho/main.dart';

void main() {
  testWidgets('School app renders key screens and switches theme mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SchoolApp());

    expect(find.text('Расписание уроков'), findsOneWidget);
    expect(find.text('Новости школы'), findsNothing);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 700);
    await tester.pumpAndSettle();
    expect(find.text('Новости школы'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 700);
    await tester.pumpAndSettle();
    expect(find.text('Тема оформления'), findsOneWidget);

    final darkCardBefore = tester.widget<Container>(
      find.byKey(const Key('dark-theme-card')),
    );
    final lightCardBefore = tester.widget<Container>(
      find.byKey(const Key('light-theme-card')),
    );

    final darkBorderBefore = darkCardBefore.decoration! as BoxDecoration;
    final lightBorderBefore = lightCardBefore.decoration! as BoxDecoration;
    expect(darkBorderBefore.border, isNotNull);
    expect(lightBorderBefore.border, isNotNull);

    await tester.tap(find.text('Светлая тема'));
    await tester.pumpAndSettle();

    final darkCardAfter = tester.widget<Container>(
      find.byKey(const Key('dark-theme-card')),
    );
    final lightCardAfter = tester.widget<Container>(
      find.byKey(const Key('light-theme-card')),
    );

    final darkBorderAfter = darkCardAfter.decoration! as BoxDecoration;
    final lightBorderAfter = lightCardAfter.decoration! as BoxDecoration;

    expect((darkBorderAfter.border! as Border).top.width, 1);
    expect((lightBorderAfter.border! as Border).top.width, 2);
  });
}
