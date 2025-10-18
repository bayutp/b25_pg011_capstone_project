import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/screen/main/main_screen.dart';
import 'package:b25_pg011_capstone_project/screen/profile/edit_profile_screen.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:b25_pg011_capstone_project/screen/login/login_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late final AuthService service;
  late final FirebaseFirestoreService firestoreService;
  late final UserLocalProvider sp;

  Future<Widget> _handleAuth(User? firebaseUser) async {
    if (firebaseUser == null) return const LoginScreen();

    final hasBusiness = await setupUser(
      service,
      sp,
      firebaseUser.uid,
      firestoreService,
    );
    return hasBusiness
        ? const MainScreen()
        : const EditProfileScreen(newUser: true);
  }

  @override
  void initState() {
    super.initState();
    service = context.read<AuthService>();
    firestoreService = context.read<FirebaseFirestoreService>();
    sp = context.read<UserLocalProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) return const LoginScreen();

        return FutureBuilder<Widget>(
          future: _handleAuth(snapshot.data),
          builder: (context, asyncSnap) {
            if (asyncSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (asyncSnap.hasError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    "Terjadi kesalahan saat memuat data",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textError.colors,
                    ),
                  ),
                ),
              );
            } else if (asyncSnap.hasData) {
              return asyncSnap.data!;
            } else {
              return const LoginScreen();
            }
          },
        );
      },
    );
  }
}

Future<bool> setupUser(
  AuthService service,
  UserLocalProvider sp,
  String uid,
  FirebaseFirestoreService firestoreService,
) async {
  final userBuzList = await service.getUserBusiness();
  final userBuz = userBuzList.where((buz) => buz.isActive == true).toList();
  final fullname = await service.getFullname();

  if (userBuz.isEmpty) return false;

  sp.getStatusUser();

  if (sp.userLocal == null || sp.userLocal!.idbuz.isEmpty) {
    await sp.setStatusUser(
      UserLocal(
        statusLogin: true,
        statusFirstLaunch: false,
        uid: uid,
        idbuz: userBuz.first.idBusiness,
        fullname: fullname,
      ),
    );
  }

  final today = DateTime.now();
  final todayStr = "${today.year}-${today.month}-${today.day}";
  final lastUpdate = sp.userLocal?.lastUpdate ?? '';

  if (lastUpdate != todayStr && sp.userLocal != null) {
    final idBuz = sp.userLocal?.idbuz ?? '';
    if (idBuz.isNotEmpty) {
      await firestoreService.updateExpiredTodos(idBuz);

      final currentUser = sp.userLocal!;
      await sp.setStatusUser(currentUser.copyWith(lastUpdate: todayStr));
    }
  }

  return true;
}
