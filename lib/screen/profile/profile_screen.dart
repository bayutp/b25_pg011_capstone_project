// lib/screen/profile/profile_screen.dart

import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/screen/profile/edit_profile_screen.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/widget/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:b25_pg011_capstone_project/widget/cardbutton_widget.dart';

// --- TAMBAHAN ---
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Untuk logout
import 'package:provider/provider.dart'; // Untuk logout

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- TAMBAHAN: Variabel untuk menampung future dari data user ---
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    // --- TAMBAHAN: Panggil fungsi untuk mengambil data saat halaman dimuat ---
    _userDataFuture = _fetchUserData();
  }

  // --- TAMBAHAN: Fungsi untuk mengambil data dari Firestore ---
  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    }
    // Jika tidak ada user, kembalikan future yang error
    return Future.error("User not logged in");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        // --- PERUBAHAN: Bungkus dengan FutureBuilder ---
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            // --- KONDISI 1: Saat data sedang dimuat ---
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // --- KONDISI 2: Jika terjadi error ---
            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return const Center(child: Text("Gagal memuat data profil."));
            }

            // --- KONDISI 3: Jika data berhasil didapatkan ---
            final userData = snapshot.data!.data()!;
            final fullName =
                "${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}";
            final position = userData['position'] ?? 'Posisi belum diatur';

            // Tampilkan UI utama dengan data dari Firebase
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?u=a',
                        ), // Placeholder image
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            position, // Data dari Firebase
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            fullName, // Data dari Firebase
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  CardButtonWidget(
                    title: 'Ubah Profile',
                    onPressed: () async {
                      // Navigasi ke EditProfileScreen
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(newUser: false),
                        ),
                      );
                      // --- TAMBAHAN: Refresh data setelah kembali dari halaman edit ---
                      if (result == true && mounted) {
                        setState(() {
                          _userDataFuture = _fetchUserData();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  CardButtonWidget(
                    title: 'Hapus Akun',
                    onPressed: () {
                      /* Logika Hapus Akun di sini */
                    },
                  ),
                  const Spacer(),
                  CardButtonWidget(
                    title: 'Log Out',
                    onPressed: () {
                      showAppConfirmationDialog(
                        context: context,
                        title: 'Log Out',
                        content: 'Anda yakin ingin keluar dari akun?',
                        confirmButtonText: 'Ya, Keluar',
                        cancelButtonText: 'Batal',
                        onConfirm: () async {
                          final sp = context.read<UserLocalProvider>();
                          final service = context.read<AuthService>();

                          await service.signOut();
                          await sp.clearDaata();
                          if (context.mounted) {
                            Navigator.popAndPushNamed(
                              context,
                              NavigationRoute.loginRoute.name,
                            );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
