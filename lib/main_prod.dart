import 'package:b25_pg011_capstone_project/firebase_options.dart';
import 'package:b25_pg011_capstone_project/main_common.dart';
import 'package:b25_pg011_capstone_project/service/sharedpreferences_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final service = SharedpreferencesService(prefs);
  final user = service.getStatusUser();

  await mainCommon(Environment.prod, user, prefs);
}
