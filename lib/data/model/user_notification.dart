import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  final String title;
  final String body;
  final bool isRead;
  final DateTime timestamp;

  UserNotification({
    required this.title,
    required this.body,
    required this.isRead,
    required this.timestamp,
  });

  // Convert from JSON
  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['isRead'] as bool,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'isRead': isRead,
      'timestamp': timestamp,
    };
  }
}
