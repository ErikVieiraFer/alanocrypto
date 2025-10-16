import 'package:alanoapp/features/auth/screens/login_screen.dart';
import 'package:alanoapp/features/dashboard/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alanoapp/features/auth/screens/auth_wrapper.dart';
import 'package:alanoapp/theme/app_theme.dart';
import 'package:alanoapp/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'AlanoCryptoFX',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const AuthWrapper(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const DashboardScreen(),
          },
        );
      },
    );
  }
}