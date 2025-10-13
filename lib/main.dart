import 'package:b25_pg011_capstone_project/provider/cashflow/transaction_type_provider.dart';
import 'package:b25_pg011_capstone_project/provider/main/bottomnav_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/screen/cashflow/add/add_cashflow_screen.dart';
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
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => SharedpreferencesService(prefs)),
        ChangeNotifierProvider(create: (context) => BottomnavProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              UserLocalProvider(context.read<SharedpreferencesService>()),
        ),
        ChangeNotifierProvider(create: (context) => TransactionTypeProvider()),
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
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: NavigationRoute.homeRoute.name,
      routes: {
        NavigationRoute.onboardingRoute.name: (context) => OnboardingScreen(),
        NavigationRoute.loginRoute.name: (context) => const LoginScreen(),
        NavigationRoute.registerRoute.name: (context) => const RegisterScreen(),
        NavigationRoute.homeRoute.name: (context) => const MainScreen(),
        NavigationRoute.addCashflow.name: (context) => AddCashflowScreen(),
      },
    );
  }
}
