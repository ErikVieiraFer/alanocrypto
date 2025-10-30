import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMiddleware {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<bool> checkUserApproval(String uid) {
    // TODO: Implementar painel admin
    return Stream.value(true);
    // return _firestore
    //     .collection('users')
    //     .doc(uid)
    //     .snapshots()
    //     .map((doc) {
    //   if (!doc.exists) {
    //     return false;
    //   }
    //   final data = doc.data();
    //   return data?['isApproved'] ?? false;
    // });
  }
}
