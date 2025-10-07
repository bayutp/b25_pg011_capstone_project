// integration_test/firebase_test_setup.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:b25_pg011_capstone_project/firebase_options.dart';

Future<void> setupFirebaseForTests() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  if (!isAndroid) {
    final host = kIsWeb ? 'localhost' : 'localhost'; // desktop/web -> localhost
    // Port HARUS sama dengan firebase.json
    try {
      FirebaseAuth.instance.useAuthEmulator(host, 9099);
    } catch (_) {}
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    } catch (_) {}

    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: false,
      );
    } catch (_) {}
  } else {}
}
