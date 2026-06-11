import 'package:flutter_test/flutter_test.dart';
import 'package:pinapp_test/main.dart';
import 'package:pinapp_test/presentation/ui/pages/home_page.dart';

void main() {
  testWidgets('App shows HomePage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(HomePage), findsOneWidget);
  });
}
