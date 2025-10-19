import 'package:b25_pg011_capstone_project/data/model/user_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init(String uid) async {
    await _initLocalNotification();
    await _initFCM(uid);
  }

  Future<void> _initFCM(String uid) async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    if (token == null) {
      await _firestore.collection('users').doc(uid).update({'fcmToken': token});
      debugPrint('FCM Token updated: $token');
    }

    // Listen jika token berubah
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await _firestore.collection('users').doc(uid).update({
        'fcmToken': newToken,
      });
      debugPrint('FCM Token refreshed');
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notif = UserNotification(
        title: message.notification?.title ?? "No Title",
        body: message.notification?.body ?? "No body",
        isRead: false,
        timestamp: (FieldValue.serverTimestamp() as Timestamp).toDate(),
      );
      await _saveToFirestore(notif, uid);
      await _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      debugPrint("Message clicked!");
    });
  }

  Future<void> _initLocalNotification() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  Future<void> _saveToFirestore(UserNotification notif, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add(notif.toJson());
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message: ${message.notification?.title}');

  final notif = UserNotification(
    title: message.notification?.title ?? "No Title",
    body: message.notification?.body ?? "No body",
    isRead: false,
    timestamp: (FieldValue.serverTimestamp() as Timestamp).toDate(),
  );

  final firestore = FirebaseFirestore.instance;
  const userId = 'USER_ID_PLACEHOLDER'; // nanti ganti dinamis
  await firestore
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .add(notif.toJson());
}
