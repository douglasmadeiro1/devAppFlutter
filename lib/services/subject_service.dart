import "package:cloud_firestore/cloud_firestore.dart";
import "package:dev_app/models/subjectModel.dart";
import "package:firebase_auth/firebase_auth.dart";

class SubjectService {
  String userId;
  SubjectService() : userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSubject(SubjectModel subjectModel) async {
    return await _firestore
        .collection("users")
        .doc(userId)
        .collection("subjects")
        .doc(subjectModel.subjectId)
        .set(subjectModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamSubject(
      bool isDescending) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("subjects")
        .orderBy("subject", descending: true)
        .snapshots();
  }

  Future<void> deleteSubject({required String subjectId}) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("subjects")
        .doc(subjectId)
        .delete();
  }
}
