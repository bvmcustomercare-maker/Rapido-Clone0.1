import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rideflow/shared/widgets/buttons/app_button.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('AppButton Tests', () {
    testWidgets('renders correctly with text', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppButton(
          text: 'Tap Me',
          onPressed: () {},
        ),
      ));

      expect(find.text('Tap Me'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppButton(
          text: 'Tap Me',
          onPressed: () {},
          isLoading: true,
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Tap Me'), findsNothing);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(buildTestWidget(
        AppButton(
          text: 'Tap Me',
          onPressed: () {
            pressed = true;
          },
        ),
      ));

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(pressed, true);
    });

    testWidgets('does not call onPressed when disabled', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(buildTestWidget(
        AppButton(
          text: 'Tap Me',
          onPressed: null,
        ),
      ));

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(pressed, false);
    });

    testWidgets('renders icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppButton(
          text: 'Icon Button',
          onPressed: () {},
          icon: Icons.check,
        ),
      ));

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
