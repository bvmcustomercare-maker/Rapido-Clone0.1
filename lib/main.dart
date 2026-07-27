import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'bootstrap.dart';
import 'core/utils/logger.dart';

/// Entrypoint to initialize the application under zone guards (ENGINEERING_GUIDE.md §2)
void main() {
  runZonedGuarded<Future<void>>(() async {
    final bootstrapResult = await bootstrap();

    runApp(
      ProviderScope(
        overrides: bootstrapResult.overrides,
        child: const RideFlowApp(),
      ),
    );
  }, (error, stackTrace) {
    AppLogger.f('Fatal unhandled error inside main zone-guard: $error', error, stackTrace);
  });
}
