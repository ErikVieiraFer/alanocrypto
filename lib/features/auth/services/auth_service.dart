import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/youtube.readonly',
    ],
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ID do canal do YouTube (será configurado pelo cliente)
  static const String CHANNEL_ID = 'ID_AQUI';

  // Stream do usuário atual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Login com Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null;
      }

      //auth details from the request
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      //new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);

      // Verificar se é membro do canal
      final isMember = await _checkYouTubeMembership(
        googleAuth.accessToken!,
      );

      if (!isMember) {
        // Se não for membro, fazer logout
        await signOut();
        throw Exception('Você precisa ser membro do canal para acessar o app');
      }

      // Salvar/atualizar dados do usuário no Firestore
      await _saveUserData(userCredential.user!);

      return userCredential;
    } catch (e) {
      print('Erro no login: $e');
      rethrow;
    }
  }

  // Verificar se o usuário é membro do canal no YouTube
  Future<bool> _checkYouTubeMembership(String accessToken) async {
    try {
      // Chamada para a API do YouTube para verificar membership
      final response = await http.get(
        Uri.parse(
          'https://www.googleapis.com/youtube/v3/members'
          '?part=snippet'
          '&hasAccessToLevel=*'
          '&myRecentSubscribers=true',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['items'] != null && data['items'].isNotEmpty;
      }

      return false;
    } catch (e) {
      print('Erro ao verificar membership: $e');
      return true; // Mudar para false em prod
    }
  }

  Future<void> _saveUserData(User user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
        'isMember': true,
      };

      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        userData['createdAt'] = FieldValue.serverTimestamp();
      }

      await userDoc.set(userData, SetOptions(merge: true));
    } catch (e) {
      print('Erro ao salvar dados do usuário: $e');
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> verifyMembershipStatus() async {
    try {
      final googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      return await _checkYouTubeMembership(googleAuth.accessToken!);
    } catch (e) {
      print('Erro ao verificar status de membro: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Erro ao obter dados do usuário: $e');
      return null;
    }
  }

  Stream<Map<String, dynamic>?> userDataStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data());
  }
}