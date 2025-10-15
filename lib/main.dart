import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/firebase_options.dart';
import 'package:b25_pg011_capstone_project/provider/main/bottomnav_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/plan_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/todo_status_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/user_plan_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/screen/login/login_screen.dart';
import 'package:b25_pg011_capstone_project/screen/main/main_screen.dart';
import 'package:b25_pg011_capstone_project/screen/onboarding/onboarding_screen.dart';
import 'package:b25_pg011_capstone_project/screen/plan/add/add_todo_screen.dart';
import 'package:b25_pg011_capstone_project/screen/plan/detail/plan_detail_screen.dart';
import 'package:b25_pg011_capstone_project/screen/register/register_screen.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/service/sharedpreferences_service.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/style/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final service = SharedpreferencesService(prefs);
  final user = service.getStatusUser();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firebaseFirestore = FirebaseFirestore.instance;

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => service),
        Provider(
          create: (context) => FirebaseFirestoreService(firebaseFirestore),
        ),
        ChangeNotifierProvider(create: (context) => BottomnavProvider()),
        ChangeNotifierProvider(create: (context) => UserLocalProvider(service)),
        ChangeNotifierProvider(create: (context) => UserPlanProvider()),
        ChangeNotifierProvider(create: (context) => PlanDateProvider()),
        ChangeNotifierProvider(create: (context) => TodoStatusProvider())
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
      themeMode: ThemeMode.light,
      initialRoute: startRoute,
      routes: {
        NavigationRoute.onboardingRoute.name: (context) => OnboardingScreen(),
        NavigationRoute.loginRoute.name: (context) => const LoginScreen(),
        NavigationRoute.registerRoute.name: (context) => const RegisterScreen(),
        NavigationRoute.homeRoute.name: (context) => const MainScreen(),
        NavigationRoute.planDetailRoute.name: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return PlanDetailScreen(planTitle: args);
        },
        NavigationRoute.addTaskRoute.name: (context) => const AddTodoScreen(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // default
        Locale('id', 'ID'), // Indonesia
      ],
    );
  }
}
