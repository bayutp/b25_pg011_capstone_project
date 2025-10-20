import 'package:b25_pg011_capstone_project/data/model/user_notification.dart';
import 'package:b25_pg011_capstone_project/data/model/user_plan.dart';
import 'package:b25_pg011_capstone_project/data/model/user_todo.dart';
import 'package:b25_pg011_capstone_project/data/model/user_cashflow.dart';
import 'package:b25_pg011_capstone_project/static/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService(FirebaseFirestore? firestoreInstance)
    : _firestore = firestoreInstance ?? FirebaseFirestore.instance;

  /*===========================================================================
  Fitur Planning
  =========================================================================== */
  Future<String> addPlan(UserPlan plan) async {
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

    final docRef = _firestore.collection('plans').doc();
    final planId = docRef.id;

    await docRef.set({...plan.toJson(), 'planId': planId});

    return planId;
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

  Future<void> addTodo(UserTodo todoData) async {
    final todo = todoData.todo.trim().toLowerCase();
    final querySnapshot = await _firestore
        .collection('todos')
        .where('planId', isEqualTo: todoData.planId)
        .where('userId', isEqualTo: todoData.userId)
        .where('businessId', isEqualTo: todoData.businessId)
        .get();

    final duplicateTodo = querySnapshot.docs.any((doc) {
      final existingTodo = (doc.data()['todo'] as String).trim().toLowerCase();
      return existingTodo == todo;
    });

    if (duplicateTodo) {
      throw Exception('Todo dengan nama "${todoData.todo}" sudah ada.');
    }

    final docRef = _firestore.collection('todos').doc();
    final todoId = docRef.id;

    await docRef.set({...todoData.toJson(), 'todoId': todoId});
  }

  Stream<List<UserTodo>> getTodosByPlanId(String planId, String businessId) {
    return _firestore
        .collection('todos')
        .where('planId', isEqualTo: planId)
        .where('businessId', isEqualTo: businessId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserTodo.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<UserTodo>> getDetailPlanByStatus(
    String planId,
    String businessId,
    String status,
  ) {
    return _firestore
        .collection('todos')
        .where('planId', isEqualTo: planId)
        .where('businessId', isEqualTo: businessId)
        .where('status', isEqualTo: status)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserTodo.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<UserTodo>> getDailyTodos(
    String businessId,
    String status,
    DateTime date,
  ) {
    final rangeDate = Helper().getDateRange("daily", date);

    final querySnapshot = _firestore
        .collection('todos')
        .where('businessId', isEqualTo: businessId)
        .where('status', isEqualTo: status)
        .where('startDate', isLessThanOrEqualTo: rangeDate['end'])
        .where('endDate', isGreaterThanOrEqualTo: rangeDate['start'])
        .snapshots();

    return querySnapshot.map(
      (snapshots) =>
          snapshots.docs.map((doc) => UserTodo.fromJson(doc.data())).toList(),
    );
  }

  Stream<List<UserTodo>> getAllDailyTodos(String businessId) {
    final rangeDate = Helper().getDateRange("daily", DateTime.now());

    final querySnapshot = _firestore
        .collection('todos')
        .where('businessId', isEqualTo: businessId)
        .where('startDate', isLessThanOrEqualTo: rangeDate['end'])
        .where('endDate', isGreaterThanOrEqualTo: rangeDate['start'])
        .orderBy('status', descending: true)
        .snapshots();

    return querySnapshot.map(
      (snapshots) =>
          snapshots.docs.map((doc) => UserTodo.fromJson(doc.data())).toList(),
    );
  }

  Stream<int> countDailyTodos(
    String userId,
    String businessId,
    DateTime date,
    String period,
  ) {
    final rangeDate = Helper().getDateRange(period, date);

    final querySnapshot = _firestore
        .collection('todos')
        .where('userId', isEqualTo: userId)
        .where('businessId', isEqualTo: businessId)
        .where('startDate', isLessThanOrEqualTo: rangeDate['end'])
        .where('endDate', isGreaterThanOrEqualTo: rangeDate['start'])
        .snapshots();

    return querySnapshot.map((snapshots) => snapshots.size);
  }

  Future<void> updateTodoStatus(String idTodo, String status) async {
    await _firestore.collection("todos").doc(idTodo).update({'status': status});
  }

  Future<void> updateExpiredTodos(String businessId) async {
    final now = DateTime.now();

    final snapshot = await _firestore
        .collection('todos')
        .where('businessId', isEqualTo: businessId)
        .where('status', isEqualTo: 'on progress')
        .where('endDate', isLessThan: now)
        .get();

    final batch = _firestore.batch();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'status': 'pending'});
    }

    await batch.commit();
  }

  /*===========================================================================
  Fitur Cashflow
  =========================================================================== */
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

  /*===========================================================================
  Fitur Notifications
  =========================================================================== */
  Stream<List<UserNotification>> getUserNotif(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection("notifications")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return UserNotification.fromJson({...data, 'id': doc.id});
          }).toList(),
        );
  }

  Future<void> markAsRead(String uid, notifId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(notifId)
        .update({'isRead': true});
  }

  Future<void> markAllRead(String uid) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  Future<void> deleteUserData(String uid) async {
    final collections = {
      'business': 'idOwner',
      'cashflows': 'userId',
      'plans': 'userId',
      'todos': 'userId',
    };

    for (final entry in collections.entries) {
      final snap = await _firestore
          .collection(entry.key)
          .where(entry.value, isEqualTo: uid)
          .get();

      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
    }

    final notifSnap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .get();

    for (final doc in notifSnap.docs) {
      await doc.reference.delete();
    }

    await _firestore.collection('users').doc(uid).delete();

    debugPrint("Semua data user $uid sudah terhapus.");
  }
}
