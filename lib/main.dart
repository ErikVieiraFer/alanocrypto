
import 'package:alanoapp/features/auth/screens/login_screen.dart';
import 'package:alanoapp/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlanoCryptoFX',
      theme: AppTheme.themeData,
      home: const LoginScreen(),
    );
  }
}
