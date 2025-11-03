import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<UserModel?> getUserStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }

  Future<bool> updateUser({
    required String userId,
    String? displayName,
    String? bio,
    String? photoURL,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      
      if (displayName != null) updates['displayName'] = displayName;
      if (bio != null) updates['bio'] = bio;
      if (photoURL != null) updates['photoURL'] = photoURL;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(userId).update(updates);
      }

      return true;
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      return false;
    }
  }

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      final String fileName = 'profile_$userId.jpg';
      final Reference ref = _storage.ref().child('profiles/$userId/$fileName');
      
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Erro ao fazer upload da imagem de perfil: $e');
      return null;
    }
  }

  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      final postsQuery = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();
      final postsCount = postsQuery.docs.length;

      final commentsQuery = await _firestore
          .collection('comments')
          .where('userId', isEqualTo: userId)
          .get();
      final commentsCount = commentsQuery.docs.length;

      int likesCount = 0;
      for (var doc in postsQuery.docs) {
        final post = doc.data();
        final likedBy = post['likedBy'] as List?;
        if (likedBy != null) {
          likesCount += likedBy.length;
        }
      }

      return {
        'posts': postsCount,
        'comments': commentsCount,
        'likes': likesCount,
      };
    } catch (e) {
      print('Erro ao buscar estatísticas: $e');
      return {'posts': 0, 'comments': 0, 'likes': 0};
    }
  }

  Future<void> createOrUpdateUser(User user) async {
    try {
      // Use SetOptions(merge: true) to create or update without reading first
      // This prevents race conditions and the "Future already completed" error
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email ?? '',
        'displayName': user.displayName ?? 'Usuário',
        'photoURL': user.photoURL ?? '',
        'lastLogin': Timestamp.fromDate(DateTime.now()),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Erro ao criar/atualizar usuário: $e');
    }
  }
}