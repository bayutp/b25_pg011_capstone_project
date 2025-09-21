import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  final username = snapshot.data!.get('username');
                  return Text(
                    'Selamat Datang, $username!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                }
                return const Text(
                  'Selamat Datang!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 16),
            if (user.email != null)
              Text(
                'Anda masuk sebagai: ${user.email}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}