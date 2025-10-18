import 'package:b25_pg011_capstone_project/auth_wrapper.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/cashflow_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/transaction_type_provider.dart';
import 'package:b25_pg011_capstone_project/provider/main/bottomnav_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/detail_status_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/plan_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/todo_status_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/user_plan_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/screen/cashflow/add/add_cashflow_screen.dart';
import 'package:b25_pg011_capstone_project/screen/login/login_screen.dart';
import 'package:b25_pg011_capstone_project/screen/main/main_screen.dart';
import 'package:b25_pg011_capstone_project/screen/onboarding/onboarding_screen.dart';
import 'package:b25_pg011_capstone_project/screen/plan/add/add_todo_screen.dart';
import 'package:b25_pg011_capstone_project/screen/plan/detail/plan_detail_screen.dart';
import 'package:b25_pg011_capstone_project/screen/profile/edit_profile_screen.dart';
import 'package:b25_pg011_capstone_project/screen/register/register_screen.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/screen/profile/profile_screen.dart';

import 'package:b25_pg011_capstone_project/service/sharedpreferences_service.dart';

import 'package:b25_pg011_capstone_project/static/navigation_route.dart';

import 'package:b25_pg011_capstone_project/style/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final service = SharedpreferencesService(prefs);
  final user = service.getStatusUser();
  final firebaseFirestore = FirebaseFirestore.instance;

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => service),
        Provider(create: (context) => SharedpreferencesService(prefs)),
        Provider(
          create: (context) => FirebaseFirestoreService(firebaseFirestore),
        ),
        Provider(
          create: (context) =>
              AuthService(context.read<SharedpreferencesService>()),
        ),
        ChangeNotifierProvider(create: (context) => BottomnavProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              UserLocalProvider(context.read<SharedpreferencesService>()),
        ),
        ChangeNotifierProvider(create: (context) => TransactionTypeProvider()),
        ChangeNotifierProvider(create: (context) => UserLocalProvider(service)),
        ChangeNotifierProvider(create: (context) => UserPlanProvider()),
        ChangeNotifierProvider(create: (context) => PlanDateProvider()),
        ChangeNotifierProvider(create: (context) => TodoStatusProvider()),
        ChangeNotifierProvider(create: (context) => DetailStatusProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              UserLocalProvider(context.read<SharedpreferencesService>()),
        ),
        ChangeNotifierProvider(create: (context) => TransactionTypeProvider()),
        ChangeNotifierProvider(create: (context) => CashflowDateProvider()),
      ],
      child: MyApp(user: user),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserLocal user;
  const MyApp({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isFirstLaunch = user.statusFirstLaunch;
    final Widget startWidget;

    if (isFirstLaunch) {
      startWidget = OnboardingScreen();
    } else {
      startWidget = const AuthWrapper();
    }

    return MaterialApp(
      title: 'Capstone Project',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,

      home: startWidget,

      routes: {
        NavigationRoute.onboardingRoute.name: (context) => OnboardingScreen(),
        NavigationRoute.loginRoute.name: (context) => const LoginScreen(),
        NavigationRoute.registerRoute.name: (context) => const RegisterScreen(),
        NavigationRoute.homeRoute.name: (context) => const MainScreen(),
        NavigationRoute.planDetailRoute.name: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final plan = args['plan'];
          final user = args['user'];
          return PlanDetailScreen(plan: plan, user: user);
        },
        NavigationRoute.addTaskRoute.name: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final plan = args['plan'];
          final user = args['user'];
          return AddTodoScreen(user: user, plan: plan);
        },
        NavigationRoute.profileRoute.name: (context) => const ProfileScreen(),
        NavigationRoute.addCashflow.name: (context) => AddCashflowScreen(),
        NavigationRoute.editProfil.name: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as bool;
          return EditProfileScreen(newUser: args);
        },
        NavigationRoute.userCheck.name: (context) => AuthWrapper(),
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
