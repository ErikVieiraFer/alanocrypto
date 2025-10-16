import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Comment>> getComments(String postId) {
    return _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();
    });
  }

  Future<bool> createComment({
    required String postId,
    required String content,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return false;

      final Comment newComment = Comment(
        id: '',
        postId: postId,
        userId: user.uid,
        userName: user.displayName ?? 'Usuário',
        userPhotoUrl: user.photoURL ?? '',
        content: content,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('comments').add(newComment.toFirestore());

      await _firestore.collection('posts').doc(postId).update({
        'commentsCount': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      print('Erro ao criar comentário: $e');
      return false;
    }
  }

  Future<bool> deleteComment(String commentId, String postId) async {
    try {
      await _firestore.collection('comments').doc(commentId).delete();

      await _firestore.collection('posts').doc(postId).update({
        'commentsCount': FieldValue.increment(-1),
      });

      return true;
    } catch (e) {
      print('Erro ao deletar comentário: $e');
      return false;
    }
  }
}