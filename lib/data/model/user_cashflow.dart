import 'package:cloud_firestore/cloud_firestore.dart';

class UserCashflow {
  final String businessId;
  final String userId;
  final double amount;
  final String type;
  final String note;
  final DateTime date;
  final String createdBy;
  final DateTime createdAt;

  UserCashflow({
    required this.businessId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.note,
    required this.date,
    required this.createdBy,
    required this.createdAt,
  });

  /// --- Convert Firestore data ke model ---
  factory UserCashflow.fromJson(Map<String, dynamic> json) {
    return UserCashflow(
      businessId: json['businessId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      note: json['note'] as String,
      date: (json['date'] as Timestamp).toDate(),
      createdBy: json['createdBy'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// --- Convert model ke Firestore data ---
  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
      'userId': userId,
      'amount': amount,
      'type': type,
      'note': note,
      'date': Timestamp.fromDate(date),
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
