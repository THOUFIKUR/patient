// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('Welcome screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MediKioskApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text('MediKiosk'), findsWidgets);
  });
}
