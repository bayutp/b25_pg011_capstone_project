import 'package:b25_pg011_capstone_project/data/model/user_cashflow.dart';
import 'package:b25_pg011_capstone_project/static/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService(FirebaseFirestore? firestoreInstance)
    : _firestore = firestoreInstance ??= FirebaseFirestore.instance;

  Future<void> addCashflow(UserCashflow cashflowData) async {
    await _firestore.collection('cashflows').add(cashflowData.toJson());
  }

  Stream<List<UserCashflow>> getCashflowsByDate(
    String userId,
    String businessId,
    DateTime date,
    String period,
  ) {
    final dateRange = Helper().getDateRange(period, date);

    final querySnapshot = _firestore
        .collection('cashflows')
        .where('userId', isEqualTo: userId)
        .where('businessId', isEqualTo: businessId)
        .where('date', isGreaterThanOrEqualTo: dateRange['start'])
        .where('date', isLessThanOrEqualTo: dateRange['end'])
        .orderBy('date', descending: true)
        .snapshots();

    return querySnapshot.map(
      (snapshots) => snapshots.docs
          .map((doc) => UserCashflow.fromJson(doc.data()))
          .toList(),
    );
  }

  Stream<num> getTotalCashflowByType(
    String userId,
    String businessId,
    DateTime date,
    String period,
    String type,
  ) {
    final dateRange = Helper().getDateRange(period, date);

    final querySnapshot = _firestore
        .collection('cashflows')
        .where('userId', isEqualTo: userId)
        .where('businessId', isEqualTo: businessId)
        .where('type', isEqualTo: type)
        .where('date', isGreaterThanOrEqualTo: dateRange['start'])
        .where('date', isLessThanOrEqualTo: dateRange['end'])
        .snapshots();

    return querySnapshot.map(
      (snapshots) => snapshots.docs
          .map((doc) => UserCashflow.fromJson(doc.data()).amount)
          .fold(0, (total, amount) => total + amount),
    );
  }

  Stream<int> getCountCashflow(
    String userId,
    String businessId,
    DateTime date,
    String period,
  ) {
    final dateRange = Helper().getDateRange(period, date);

    final querySnapshot = _firestore
        .collection('cashflows')
        .where('userId', isEqualTo: userId)
        .where('businessId', isEqualTo: businessId)
        .where('date', isGreaterThanOrEqualTo: dateRange['start'])
        .where('date', isLessThanOrEqualTo: dateRange['end'])
        .snapshots();

    return querySnapshot.map((snapshots) => snapshots.size);
  }
}
