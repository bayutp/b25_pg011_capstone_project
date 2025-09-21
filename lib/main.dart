import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:b25_pg011_capstone_project/provider/main/bottomnav_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/service/sharedpreferences_service.dart';
import 'package:b25_pg011_capstone_project/style/theme/app_theme.dart';
import 'package:b25_pg011_capstone_project/auth_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => SharedpreferencesService(prefs)),
        ChangeNotifierProvider(create: (context) => BottomnavProvider()),
        ChangeNotifierProvider(
          create: (context) => UserLocalProvider(context.read<SharedpreferencesService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capstone Project',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      home: const AuthWrapper(),

      // routes: {
      //   NavigationRoute.onboardingRoute.name: (context) => OnboardingScreen(),
      //   NavigationRoute.loginRoute.name: (context) => const LoginScreen(),
      //   NavigationRoute.registerRoute.name: (context) => const RegisterScreen(),
      //   NavigationRoute.homeRoute.name: (context) => const MainScreen(),
      // },
    );
  }
}