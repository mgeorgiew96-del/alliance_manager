import 'package:alliance_manager/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Alliance Manager app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AllianceManagerApp());

    expect(find.text('APX Alliance Manager'), findsOneWidget);
  });
}