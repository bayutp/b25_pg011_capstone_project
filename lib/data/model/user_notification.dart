import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime timestamp;

  UserNotification({
    this.id = '',
    required this.title,
    required this.body,
    required this.isRead,
    required this.timestamp,
  });

  // Convert from JSON
  factory UserNotification.fromJson(Map<String, dynamic> json) {
    final timestampField = json['timestamp'];
    return UserNotification(
      id: json['id'],
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['isRead'] as bool,
      timestamp: timestampField is Timestamp
          ? timestampField.toDate()
          : DateTime.now(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'isRead': isRead,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
