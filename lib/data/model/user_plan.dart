import 'package:cloud_firestore/cloud_firestore.dart';

class UserPlan {
  final String planId;
  final String businessId;
  final String userId;
  final String name;
  final String createdBy;
  final DateTime createdAt;

  UserPlan({
    this.planId = '',
    required this.businessId,
    required this.userId,
    required this.name,
    required this.createdBy,
    required this.createdAt,
  });

  factory UserPlan.fromJson(Map<String, dynamic> json) {
    return UserPlan(
      planId: json['planId'] as String,
      businessId: json['businessId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'businessId': businessId,
      'userId': userId,
      'name': name,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}