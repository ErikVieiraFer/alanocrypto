import 'package:alanoapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:alanoapp/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }



  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithGoogle();
      // Don't navigate manually - let AuthWrapper handle it automatically
      // when authStateChanges fires
      // If user is null, it might be redirect (Safari) - no error needed
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();

        // Clean up error message
        if (errorMessage.startsWith('AuthException:')) {
          errorMessage = errorMessage.replaceFirst('AuthException:', '').trim();
        }

        // Não mostrar erro se usuário cancelou
        if (!errorMessage.contains('cancelado pelo usuário') &&
            !errorMessage.contains('user-cancelled')) {
          _showErrorDialog('Erro ao fazer login', errorMessage);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.getSecondaryBackgroundColor(context),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppTheme.getTextColor(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppTheme.getTextColor(context),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: AppTheme.getPrimaryColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.getTextColor(context);
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor60 = AppTheme.getTextColor60(context);
    final primaryColor20 = AppTheme.getPrimaryColor20(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: secondaryBackground,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/logo.jpeg',
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: primaryColor20,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.currency_bitcoin,
                            size: 48,
                            color: primaryColor,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'AC',
                          style: TextStyle(
                            color: AppTheme.greenSecondary,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'AlanoCryptoFX',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  'Entrar',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Faça login para acessar conteúdo exclusivo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor60,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 32),

                if (_isLoading)
                  CircularProgressIndicator(color: primaryColor)
                else
                  OutlinedButton.icon(
                    onPressed: _loginWithGoogle,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: Icon(
                      Icons.g_mobiledata,
                      color: primaryColor,
                      size: 32,
                    ),
                    label: Text(
                      'Entrar com Google',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 32),

                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.youtube,
                    color: Colors.red,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Seja membro do canal para acessar',
                  style: TextStyle(
                    color: textColor60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}