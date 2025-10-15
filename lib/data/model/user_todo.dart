import 'package:cloud_firestore/cloud_firestore.dart';

class UserTodo {
  final String todoId;
  final String planId;
  final String userId;
  final String businessId;
  final String todo;
  final String plan;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String createdBy;
  final DateTime createdAt;

  UserTodo({
    this.todoId = '',
    required this.planId,
    required this.userId,
    required this.businessId,
    required this.todo,
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdBy,
    required this.createdAt,
  });

  factory UserTodo.fromJson(Map<String, dynamic> json) {
    return UserTodo(
      todoId: json['todoId'] as String,
      planId: json['planId'] as String,
      userId: json['userId'] as String,
      businessId: json['businessId'] as String,
      todo: json['todo'] as String,
      plan: json['plan'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      status: json['status'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todoId': todoId,
      'planId': planId,
      'userId': userId,
      'businessId': businessId,
      'todo': todo,
      'plan': plan,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
