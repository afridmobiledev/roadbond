// Dart (Flutter)
import 'package:flutter_test/flutter_test.dart';
import 'package:roadbond/main.dart';

void main() {
  testWidgets('shows the Road Bond onboarding screen', (tester) async {
    await tester.pumpWidget(const RoadBondApp());
    await tester.pumpAndSettle();

    expect(find.text('ROAD BOND'), findsOneWidget);
    expect(find.text('Ride together.\nGo somewhere new.'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}
