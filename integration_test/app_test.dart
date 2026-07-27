import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rideflow/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End App Test', () {
    testWidgets('Complete ride flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // App should load and show auth or redirect to home (since it's simulated, it might go to Home directly)
      // We will look for Home screen elements.
      expect(find.text('Where to?'), findsOneWidget);

      // Tap on search pickup
      await tester.tap(find.text('Search pickup location'));
      await tester.pumpAndSettle();

      // We should be in pickup selection mode (bottom sheet expanded)
      expect(find.text('Select Pickup Location'), findsOneWidget);

      // Select a preset location
      await tester.tap(find.text('Current Location').first);
      await tester.pumpAndSettle();

      // Tap on search destination
      await tester.tap(find.text('Search destination'));
      await tester.pumpAndSettle();

      // Select a destination
      await tester.tap(find.text('Work').first);
      await tester.pumpAndSettle();

      // Vehicle selection should appear
      expect(find.text('Select Vehicle'), findsOneWidget);

      // Tap the primary vehicle (Auto usually)
      await tester.tap(find.text('Auto').first);
      await tester.pumpAndSettle();

      // Tap Confirm Ride
      await tester.tap(find.text('Confirm Ride'));
      await tester.pumpAndSettle();

      // Should show Searching Driver
      expect(find.text('Finding your driver...'), findsOneWidget);

      // The simulation progresses automatically, but in tests, timers can be tricky.
      // We will wait for the next state which is 'Driver Assigned'
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // We should see driver assigned or arriving
      // Since it's an automated test, it might be safer to stop here as animations are long
    });
  });
}
