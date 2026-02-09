import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/router.dart';
import 'core/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services before running the app
  await _initializeServices();

  runApp(const ProviderScope(child: SomSafarApp()));
}

/*************   *************/
/// Initializes Firebase and the database with default data if needed.
///
/// This function is called before running the app to ensure that all services are initialized properly.
/// If the Firebase initialization fails, an error message is printed to the console.
///
/// Returns a [Future<void>] that completes when the initialization is finished.

Future<void> _initializeServices() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize database with default data if needed
    final databaseService = DatabaseService();
    await databaseService.initializeDatabase();
    debugPrint('Firebase and Database initialized successfully');
  } catch (e) {
    // Handle Firebase initialization failure
    debugPrint('Firebase initialization failed: $e');
  }
}

class SomSafarApp extends ConsumerWidget {
  const SomSafarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'SomSafar',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
