import 'package:flutter_test/flutter_test.dart';
import 'package:hahahoho/main.dart';

void main() {
  testWidgets('renders school app home title', (WidgetTester tester) async {
    await tester.pumpWidget(const SchoolApp());

    expect(find.text('Школьное\nприложение'), findsOneWidget);
    expect(find.text('Расписание уроков'), findsOneWidget);
  });
}
