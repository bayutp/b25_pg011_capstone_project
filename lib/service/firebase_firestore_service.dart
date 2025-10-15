import 'package:b25_pg011_capstone_project/data/model/user_plan.dart';
import 'package:b25_pg011_capstone_project/data/model/user_todo.dart';
import 'package:b25_pg011_capstone_project/static/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService(FirebaseFirestore? firestoreInstance)
    : _firestore = firestoreInstance ?? FirebaseFirestore.instance;

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
        .where('startDate', isGreaterThanOrEqualTo: rangeDate['start'])
        .where('startDate', isLessThanOrEqualTo: rangeDate['end'])
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
    final dateRange = Helper().getDateRange(period, date);

    final querySnapshot = _firestore
        .collection('todos')
        .where('userId', isEqualTo: userId)
        .where('businessId', isEqualTo: businessId)
        .where('startDate', isGreaterThanOrEqualTo: dateRange['start'])
        .where('startDate', isLessThanOrEqualTo: dateRange['end'])
        .snapshots();

    return querySnapshot.map((snapshots) => snapshots.size);
  }
}
