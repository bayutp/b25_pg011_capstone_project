import 'package:cloud_firestore/cloud_firestore.dart';

class UserPlan {
  final String businessId;
  final String userId;
  final String name;
  final String createdBy;
  final DateTime createdAt;

  UserPlan({
    required this.businessId,
    required this.userId,
    required this.name,
    required this.createdBy,
    required this.createdAt,
  });

  factory UserPlan.fromJson(Map<String, dynamic> json) {
    return UserPlan(
      businessId: json['businessId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
      'userId': userId,
      'name': name,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}