import 'package:b25_pg011_capstone_project/data/model/user_notification.dart';
import 'package:b25_pg011_capstone_project/service/sharedpreferences_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _initialized = false;

  Future<void> init(String uid) async {
    if (_initialized) return;
    _initialized = true;

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
    if (token != null) {
      await _firestore.collection('users').doc(uid).update({'fcmToken': token});
      debugPrint('FCM Token updated');
    } else {
      debugPrint('Gagal dapat FCM Token');
    }

    // Listen jika token berubah
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await _firestore.collection('users').doc(uid).update({
        'fcmToken': newToken,
      });
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notif = UserNotification(
        title: message.notification?.title ?? "No Title",
        body: message.notification?.body ?? "No body",
        isRead: false,
        timestamp: DateTime.now(),
      );
      await _showNotification(message);
      if (uid.isNotEmpty) {
        await _saveToFirestore(notif, uid);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage remoteMessage,
    ) async {
      final notifId = remoteMessage.data['notificationId'];
      final userId = remoteMessage.data['userId'];

      if (notifId != null && userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .doc(notifId)
            .update({'isRead': true});
        debugPrint("Notifikasi $notifId ditandai sebagai read");
      }
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
    final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(
      100000,
    );
    await _localNotifications.show(
      notificationId,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  Future<void> _saveToFirestore(UserNotification notif, String userId) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc();

      final notifId = docRef.id;
      await docRef.set({...notif.toJson(), 'id': notifId});
    } catch (e) {
      debugPrint('Notif >> Error save notif: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;
  final prefs = await SharedPreferences.getInstance();
  final sp = SharedpreferencesService(prefs);
  final userId = sp.getStatusUser().uid;

  if (userId.isNotEmpty) {
    try {
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc();

      debugPrint('Notif >> saved with ID: ${docRef.id}');

      final notif = UserNotification(
        id: docRef.id,
        title: message.notification?.title ?? "No Title",
        body: message.notification?.body ?? "No body",
        isRead: false,
        timestamp: DateTime.now(),
      );

      await docRef.set({...notif.toJson(), 'id': notif.id});
    } catch (e, st) {
      debugPrint('Notif >> Stacktrace: $st');
    }
  }
}
