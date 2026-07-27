import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rideflow/shared/widgets/feedback/app_skeleton.dart';

void main() {
  Widget buildTestWidget({required bool isDark}) {
    return MaterialApp(
      home: Scaffold(
        body: AppSkeleton(
          width: 100,
          height: 50,
          isDark: isDark,
        ),
      ),
    );
  }

  group('AppSkeleton Tests', () {
    testWidgets('renders skeleton correctly in light mode', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(isDark: false));
      
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
    });

    testWidgets('renders skeleton correctly in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(isDark: true));
      
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
    });
  });
}
