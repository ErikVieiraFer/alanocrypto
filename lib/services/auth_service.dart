import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'user_service.dart';

// Conditional import for web-specific functionality
import 'package:universal_html/html.dart' as html;

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

  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider.setCustomParameters({
          'prompt': 'select_account'
        });

        // Detectar Safari/iOS e usar redirect
        final userAgent = html.window.navigator.userAgent;
        final isSafari = userAgent.contains('Safari') && !userAgent.contains('Chrome');
        final isIOS = userAgent.contains('iPhone') || userAgent.contains('iPad') || userAgent.contains('iPod');

        if (isSafari || isIOS) {
          // Usar redirect para Safari/iOS
          await _auth.signInWithRedirect(googleProvider);
          return null; // O resultado será tratado pelo getRedirectResult
        } else {
          // Usar popup para outros browsers
          final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);

          if (userCredential.user != null) {
            await _userService.createOrUpdateUser(userCredential.user!);
          }

          return userCredential.user;
        }
      } else {
        await _googleSignIn.signOut();

        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return null;
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
      print('Erro no login com Google: $e');
      return null;
    }
  }

  /// Método para processar o resultado do redirect (Safari/iOS)
  Future<User?> handleRedirectResult() async {
    try {
      if (kIsWeb) {
        final UserCredential? userCredential = await _auth.getRedirectResult();

        if (userCredential != null && userCredential.user != null) {
          await _userService.createOrUpdateUser(userCredential.user!);
          return userCredential.user;
        }
      }
      return null;
    } catch (e) {
      print('Erro ao processar redirect: $e');
      return null;
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