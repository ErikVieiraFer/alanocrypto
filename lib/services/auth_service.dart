import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'user_service.dart';

// Conditional import for web-specific functionality
import 'package:universal_html/html.dart' as html;

class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  AuthService() {
    _googleSignIn = GoogleSignIn(
      clientId: kIsWeb
        ? '755553491761-104atot6h03fbut33jq6r2fasgnf32sb.apps.googleusercontent.com'
        : null,
    );
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-cancelled':
        case 'cancelled-popup-request':
          return 'Login cancelado pelo usuário';
        case 'popup-blocked':
          return 'Pop-up bloqueado. Permita pop-ups para este site';
        case 'popup-closed-by-user':
          return 'Pop-up fechado antes de concluir o login';
        case 'network-request-failed':
          return 'Conexão perdida. Verifique sua internet';
        case 'too-many-requests':
          return 'Muitas tentativas. Aguarde alguns minutos';
        case 'user-disabled':
          return 'Usuário desabilitado. Entre em contato com o suporte';
        case 'web-storage-unsupported':
          return 'Navegador bloqueando cookies. Ative cookies e tente novamente';
        case 'unauthorized-domain':
          return 'Domínio não autorizado. Entre em contato com o suporte';
        case 'invalid-credential':
          return 'Credenciais inválidas. Tente novamente';
        case 'account-exists-with-different-credential':
          return 'Conta já existe com outro método de login';
        default:
          if (error.message?.contains('missing initial state') ?? false) {
            return 'Erro no Safari. Tente: 1) Ativar cookies, 2) Desativar "Prevent Cross-Site Tracking", ou 3) Use Chrome/Firefox';
          }
          return 'Erro ao fazer login: ${error.message ?? error.code}';
      }
    }

    final errorString = error.toString();
    if (errorString.contains('missing initial state')) {
      return 'Erro no Safari. Tente: 1) Ativar cookies, 2) Desativar "Prevent Cross-Site Tracking", ou 3) Use Chrome/Firefox';
    }

    return 'Erro inesperado: $error';
  }

  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        // Tentar popup primeiro (funciona melhor no Safari moderno)
        try {
          final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);

          if (userCredential.user != null) {
            await _userService.createOrUpdateUser(userCredential.user!);
          }

          return userCredential.user;
        } catch (popupError) {
          // Se popup falhar, detectar navegador e decidir estratégia
          final userAgent = html.window.navigator.userAgent;
          final isSafari = userAgent.contains('Safari') && !userAgent.contains('Chrome');
          final isIOS = userAgent.contains('iPhone') || userAgent.contains('iPad') || userAgent.contains('iPod');

          // Se for Safari/iOS e popup falhou, tentar redirect
          if (isSafari || isIOS) {
            // Salvar flag indicando que estamos fazendo redirect
            html.window.sessionStorage['auth_redirect_pending'] = 'true';
            await _auth.signInWithRedirect(googleProvider);
            return null; // O resultado será tratado pelo handleRedirectResult
          } else {
            // Se não for Safari/iOS, popup deveria ter funcionado
            throw popupError;
          }
        }
      } else {
        // Mobile (Android/iOS)
        await _googleSignIn.signOut();

        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          throw AuthException('user-cancelled', 'Login cancelado pelo usuário');
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          await _userService.createOrUpdateUser(userCredential.user!);
        }

        return userCredential.user;
      }
    } catch (e) {
      final errorMessage = _getErrorMessage(e);
      print('Erro no login com Google: $errorMessage');
      throw AuthException('login-failed', errorMessage);
    }
  }

  /// Método para processar o resultado do redirect (Safari/iOS)
  Future<User?> handleRedirectResult() async {
    try {
      if (kIsWeb) {
        // Verificar se há redirect pendente
        final redirectPending = html.window.sessionStorage['auth_redirect_pending'];

        final UserCredential? userCredential = await _auth.getRedirectResult();

        if (userCredential != null && userCredential.user != null) {
          // Limpar flag de redirect pendente
          html.window.sessionStorage.remove('auth_redirect_pending');

          await _userService.createOrUpdateUser(userCredential.user!);
          return userCredential.user;
        }

        // Se não há credential mas havia redirect pendente, algo deu errado
        if (redirectPending == 'true') {
          html.window.sessionStorage.remove('auth_redirect_pending');
          throw AuthException(
            'redirect-failed',
            'Falha ao processar login. Tente novamente',
          );
        }
      }
      return null;
    } catch (e) {
      final errorMessage = _getErrorMessage(e);
      print('Erro ao processar redirect: $errorMessage');
      throw AuthException('redirect-error', errorMessage);
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      print('Erro no logout: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
    String? bio,
  }) async {
    try {
      final user = currentUser;
      if (user == null) return;

      final updates = <String, dynamic>{};
      
      if (displayName != null) {
        updates['displayName'] = displayName;
        await user.updateDisplayName(displayName);
      }
      
      if (photoURL != null) {
        updates['photoURL'] = photoURL;
        await user.updatePhotoURL(photoURL);
      }
      
      if (bio != null) {
        updates['bio'] = bio;
      }

      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        await _firestore.collection('users').doc(user.uid).update(updates);
      }
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      rethrow;
    }
  }
}