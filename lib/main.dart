import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/di/app_bootstrap.dart';
import 'core/di/service_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final overrides = await bootstrapApp();
  final container = ProviderContainer(overrides: overrides);

  // Route framework-level errors (widget build failures, etc.) through the
  // crash reporting interface instead of only the console, from day one —
  // even though the concrete implementation is a NoOp until the Firebase
  // integration phase.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    container.read(crashReportingServiceProvider).recordError(
          details.exception,
          details.stack,
          fatal: true,
          context: {'library': details.library},
        );
  };

  await initializeRuntimeServices(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const VyomVidyaApp(),
    ),
  );
}
