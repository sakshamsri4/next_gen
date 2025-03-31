import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

// Try to import the real Firebase options first
// This is ignored in CI environment due to .gitignore
import 'package:next_gen/firebase_options.dart' as firebase_real;
// We use the real Firebase options by default, but fall back to CI options if
// the real ones are not available
import 'package:next_gen/firebase_options_ci.dart' as firebase_ci;

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if Firebase is already initialized to prevent duplicate initialization
  if (Firebase.apps.isEmpty) {
    // Initialize Firebase with the real options, falling back to CI options
    try {
      await Firebase.initializeApp(
        options: firebase_real.DefaultFirebaseOptions.currentPlatform,
      );
      log('Using real Firebase configuration');
    } catch (e) {
      // Only try the fallback if it's not already initialized
      if (Firebase.apps.isEmpty) {
        debugPrint('Using CI Firebase configuration $e');
        await Firebase.initializeApp(
          options: firebase_ci.DefaultFirebaseOptions.currentPlatform,
        );
        log('Using CI Firebase configuration');
      }
    }
  } else {
    log('Firebase already initialized, skipping initialization');
  }

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  runApp(await builder());
}
