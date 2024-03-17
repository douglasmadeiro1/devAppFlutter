import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_app/models/contentModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentService {
  String userId;
  ContentService() : userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addContent({
    required String subjectId,
    required ContentModel contentModel,
  }) async {
    if (subjectId.isEmpty) {
      throw Exception('O subjectId não pode ser vazio.');
    }
    return await _firestore
        .collection("users")
        .doc(userId)
        .collection("subjects")
        .doc(subjectId)
        .collection("contents")
        .doc(contentModel.contentId)
        .set(contentModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamContent(
      {required String subjectId}) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("subjects")
        .doc(subjectId)
        .collection("contents")
        .orderBy('content', descending: true)
        .snapshots();
  }

  Future<void> deleteContent(
      {required String subjectId, required String contentId}) async {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("subjects")
        .doc(subjectId)
        .collection("contents")
        .doc(contentId)
        .delete();
  }

  Future<void> updateContent({
    required String subjectId,
    required ContentModel contentModel,
    required String contentId,
  }) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("subjects")
        .doc(subjectId)
        .collection("contents")
        .doc(contentId)
        .update(contentModel.toMap());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getContent({
    required String subjectId,
    required String contentId,
  }) async {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("subjects")
        .doc(subjectId)
        .collection("contents")
        .doc(contentId)
        .get();
  }
}
