import 'package:flutter_test/flutter_test.dart';
import 'package:roadbond/main.dart';

void main() {
  testWidgets('shows the discover rides screen', (tester) async {
    await tester.pumpWidget(const RoadBondApp());

    expect(find.text('Discover rides'), findsOneWidget);
    expect(find.text('Sunday Hudson Valley Ride'), findsOneWidget);
  });
}