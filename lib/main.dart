import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'theme/theme_provider.dart';
import 'theme/app_theme.dart';
import 'features/auth/screens/landing_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/auth/screens/pending_approval_screen.dart';
import 'features/dashboard/screen/dashboard_screen.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'middleware/auth_middleware.dart';
import 'package:alanoapp/firebase_options.dart';

void main() {
  // Global error handler to suppress known FlutterFire web interop error
  FlutterError.onError = (FlutterErrorDetails details) {
    final error = details.exception.toString();
    if (error.contains('JavaScriptObject') ||
        error.contains('_testException') ||
        error.contains('ArgumentError')) {
      // Suppress known FlutterFire web interop error
      debugPrint('Suprimindo erro conhecido do FlutterFire: ${details.exception}');
      return;
    }
    FlutterError.presentError(details);
  };

  // Catch errors in async code - EVERYTHING must be inside runZonedGuarded
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        // Only activate App Check on non-web platforms to avoid conflicts
        if (!kIsWeb) {
          await FirebaseAppCheck.instance.activate(
            androidProvider: AndroidProvider.debug,
            appleProvider: AppleProvider.debug,
          );
        }
      } catch (e) {
        if (e.toString().contains('duplicate-app')) {
          // Firebase already initialized
        } else {
          rethrow;
        }
      }

      timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

      runApp(const MyApp());
    },
    (error, stack) {
      // Catch uncaught async errors
      if (error.toString().contains('JavaScriptObject') ||
          error.toString().contains('_testException') ||
          error.toString().contains('ArgumentError')) {
        debugPrint('Suprimindo erro assíncrono conhecido do FlutterFire: $error');
        return;
      }
      debugPrint('Erro não tratado: $error');
      debugPrint('Stack trace: $stack');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          title: 'AlanoCryptoFX',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const AuthWrapper(),
          routes: {
            '/landing': (context) => const LandingScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/pending-approval': (context) => const PendingApprovalScreen(),
            '/dashboard': (context) => const DashboardScreen(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userService = UserService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<bool>(
            future: userService.isUserApproved(snapshot.data!.uid),
            builder: (context, approvalSnapshot) {
              if (approvalSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (approvalSnapshot.hasData && approvalSnapshot.data == true) {
                return const DashboardScreen();
              }

              return const PendingApprovalScreen();
            },
          );
        }

        return const LandingScreen();
      },
    );
  }
}
