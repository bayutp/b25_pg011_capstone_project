import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/provider/main/bottomnav_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/screen/login/login_screen.dart';
import 'package:b25_pg011_capstone_project/screen/main/main_screen.dart';
import 'package:b25_pg011_capstone_project/screen/onboarding/onboarding_screen.dart';
import 'package:b25_pg011_capstone_project/screen/register/register_screen.dart';
import 'package:b25_pg011_capstone_project/service/sharedpreferences_service.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/style/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final service = SharedpreferencesService(prefs);
  final user = service.getStatusUser();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => service),
        ChangeNotifierProvider(create: (context) => BottomnavProvider()),
        ChangeNotifierProvider(create: (context) => UserLocalProvider(service)),
      ],
      child: MyApp(user: user),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserLocal user;
  const MyApp({super.key, required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final String startRoute;
    final isLoggedIn = user.statusLogin;
    final isFirstLaunch = user.statusFirstLaunch;

    debugPrint("login: $isLoggedIn app launch: $isFirstLaunch");

    if (isLoggedIn) {
      startRoute = NavigationRoute.homeRoute.name;
    } else if (!isLoggedIn && !isFirstLaunch) {
      startRoute = NavigationRoute.loginRoute.name;
    } else {
      startRoute = NavigationRoute.onboardingRoute.name;
    }

    return MaterialApp(
      title: 'Capstone Project',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: startRoute,
      routes: {
        NavigationRoute.onboardingRoute.name: (context) => OnboardingScreen(),
        NavigationRoute.loginRoute.name: (context) => const LoginScreen(),
        NavigationRoute.registerRoute.name: (context) => const RegisterScreen(),
        NavigationRoute.homeRoute.name: (context) => const MainScreen(),
      },
    );
  }
}
