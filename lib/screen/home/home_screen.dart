// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil info user yang sedang login
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          // Tombol untuk Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // AuthWrapper akan otomatis handle navigasi ke LoginPage
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Selamat datang, ${user?.email ?? 'Pengguna'}!"),
      ),
    );
  }
}