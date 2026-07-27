import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rideflow/shared/widgets/feedback/app_empty_state.dart';
import 'package:rideflow/shared/widgets/buttons/app_button.dart';

void main() {
  Widget buildTestWidget({String? actionLabel, VoidCallback? onAction}) {
    return MaterialApp(
      home: Scaffold(
        body: AppEmptyState(
          title: 'No Data',
          subtitle: 'Please check back later.',
          icon: Icons.inbox,
          isDark: false,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
      ),
    );
  }

  group('AppEmptyState Tests', () {
    testWidgets('renders title, subtitle, and icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('No Data'), findsOneWidget);
      expect(find.text('Please check back later.'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('renders action button if actionLabel and onAction are provided', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(buildTestWidget(
        actionLabel: 'Retry',
        onAction: () {
          pressed = true;
        },
      ));

      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(pressed, true);
    });
  });
}
