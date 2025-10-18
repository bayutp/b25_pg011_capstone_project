import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/screen/main/main_screen.dart';
import 'package:b25_pg011_capstone_project/screen/profile/edit_profile_screen.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
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
  late final UserLocalProvider sp;

  Future<Widget> _handleAuth(User? firebaseUser) async {
    if (firebaseUser == null) return const LoginScreen();

    final hasBusiness = await setupUser(service, sp, firebaseUser.uid);
    return hasBusiness ? const MainScreen() : const EditProfileScreen(newUser: true,);
  }

  @override
  void initState() {
    super.initState();
    service = context.read<AuthService>();
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
                  return const EditProfileScreen(newUser: true,);
                } else if (asyncSnap.hasData) {
                  return asyncSnap.data!;
                } else {
                  return const LoginScreen();
                }
              },
            );
          },
        );
      },
    );
  }

  Future<bool> setupUser(
    AuthService service,
    UserLocalProvider sp,
    String uid,
  ) async {
    final userBuzList = await service.getUserBusiness();
    final userBuz = userBuzList.where((buz) => buz.isActive == true).toList();
    final fullname = await service.getFullname();

    if (userBuz.isNotEmpty) {
      sp.getStatusUser();
      if (sp.userLocal!.idbuz.isEmpty) {
        sp.setStatusUser(
          UserLocal(
            statusLogin: true,
            statusFirstLaunch: false,
            uid: uid,
            idbuz: userBuz.first.idBusiness,
            fullname: fullname,
          ),
        );
      }
      return true;
    }
    return false;
  }
}
