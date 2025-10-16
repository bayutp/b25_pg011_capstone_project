import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:b25_pg011_capstone_project/screen/login/login_screen.dart';
import 'package:b25_pg011_capstone_project/screen/main/main_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Stream yang akan update otomatis kalau status login berubah
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Masih nunggu respon dari FirebaseAuth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Kalau user ada (berhasil login / masih login)
        if (snapshot.hasData) {
          return const MainScreen();
        }

        // Kalau belum login
        return const LoginScreen();
      },
    );
  }
}
