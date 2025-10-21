import 'dart:ui';

import 'package:b25_pg011_capstone_project/auth_wrapper.dart';
import 'package:b25_pg011_capstone_project/data/api/api_service.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/cashflow_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/transaction_type_provider.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/user_income_providers.dart';
import 'package:b25_pg011_capstone_project/provider/main/bottomnav_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/detail_status_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/plan_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/todo_status_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/user_plan_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_image_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/screen/auth/forgotpswd/forgot_pswd_screen.dart';
import 'package:b25_pg011_capstone_project/screen/auth/register/register_screen.dart';
import 'package:b25_pg011_capstone_project/screen/cashflow/add/add_cashflow_screen.dart';
import 'package:b25_pg011_capstone_project/screen/auth/login/login_screen.dart';
import 'package:b25_pg011_capstone_project/screen/cashflow/history/cashflow_history_screen.dart';
import 'package:b25_pg011_capstone_project/screen/main/main_screen.dart';
import 'package:b25_pg011_capstone_project/screen/notification/notif_screen.dart';
import 'package:b25_pg011_capstone_project/screen/onboarding/onboarding_screen.dart';
import 'package:b25_pg011_capstone_project/screen/plan/add/add_todo_screen.dart';
import 'package:b25_pg011_capstone_project/screen/plan/detail/plan_detail_screen.dart';
import 'package:b25_pg011_capstone_project/screen/profile/edit_profile_screen.dart';
import 'package:b25_pg011_capstone_project/screen/splash/splash_screen.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/screen/profile/profile_screen.dart';
import 'package:b25_pg011_capstone_project/service/notification_service.dart';

import 'package:b25_pg011_capstone_project/service/sharedpreferences_service.dart';

import 'package:b25_pg011_capstone_project/static/navigation_route.dart';

import 'package:b25_pg011_capstone_project/style/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final notificationService = NotificationService();
  if (user.uid.isNotEmpty && user.statusLogin) {
    await notificationService.init(user.uid);
  }

  await dotenv.load(fileName: '.env');

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => service),
        Provider(create: (context) => notificationService),
        Provider(create: (context) => ApiService()),
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
        ChangeNotifierProvider(create: (context) => UserImageProvider()),
        ChangeNotifierProvider(
          create: (context) => UserIncomeProvider(
            context.read<FirebaseFirestoreService>(),
            context.read<UserLocalProvider>().userLocal!.uid,
            context.read<UserLocalProvider>().userLocal!.idbuz,
          ),
        ),
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
    return MaterialApp(
      title: 'Capstone Project',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,

      initialRoute: NavigationRoute.splashRoute.name,

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
        NavigationRoute.forgotPswd.name: (context) => ForgotPasswordScreen(),
        NavigationRoute.notification.name: (context) => NotifScreen(),
        NavigationRoute.splashRoute.name: (context) => SplashScreen(),
        NavigationRoute.casflowHistoryRoute.name: (context) =>
            CashflowHistoryScreen(),
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
