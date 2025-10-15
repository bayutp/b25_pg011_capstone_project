import 'package:b25_pg011_capstone_project/data/model/user_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService(FirebaseFirestore? firestoreInstance)
    : _firestore = firestoreInstance ?? FirebaseFirestore.instance;

  Future<void> addPlan(UserPlan plan) async {
    final name = plan.name.trim().toLowerCase();
    final querySnapshot = await _firestore
        .collection('plans')
        .where('userId', isEqualTo: plan.userId)
        .where('businessId', isEqualTo: plan.businessId)
        .get();

    final duplicateName = querySnapshot.docs.any((doc) {
      final existingName = (doc.data()['name'] as String).trim().toLowerCase();
      return existingName == name;
    });

    if (duplicateName) {
      throw Exception('Kategori dengan nama "${plan.name}" sudah ada.');
    }

    await _firestore.collection('plans').add(plan.toJson());
  }

  Stream<List<UserPlan>> getPlansByUserId(String userId, String businessId) {
    return _firestore
        .collection('plans')
        .where('userId', isEqualTo: userId)
        .where('businessId', isEqualTo: businessId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserPlan.fromJson(doc.data()))
              .toList(),
        );
  }
}
