import 'package:flutter/material.dart';
// 1. Impor kedua widget kustom Anda di sini
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/bottomnav_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variabel state untuk mengontrol item aktif di navigasi bawah
  int _selectedIndex = 3; // Dimulai dari index 3 (Profil)

  // Fungsi yang akan dipanggil saat item navigasi ditekan
  // Fungsi ini akan kita teruskan ke BottomnavWidget
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Halaman
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Bagian Info Pengguna
              const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=johndoe'), // Ganti dengan URL gambar Anda
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Founder',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 2. Menggunakan ButtonWidget untuk semua tombol aksi
              ButtonWidget(
                title: 'Ubah Profile',
                textColor: Colors.black,
                foregroundColor: Colors.white,
                backgroundColor: Colors.white,
                onPressed: () {
                  print('Tombol Ubah Profile ditekan');
                  // Tambahkan aksi navigasi atau logika lainnya di sini
                },
              ),
              const SizedBox(height: 15),
              ButtonWidget(
                title: 'Hapus Akun',
                textColor: Colors.black,
                foregroundColor: Colors.white,
                backgroundColor: Colors.white,
                onPressed: () {
                  print('Tombol Hapus Akun ditekan');
                },
              ),

              // Spacer untuk mendorong tombol Log Out ke bawah
              const Spacer(),

              ButtonWidget(
                title: 'Log Out',
                textColor: Colors.black,
                foregroundColor: Colors.white,
                backgroundColor: Colors.white,
                onPressed: () {
                  print('Tombol Log Out ditekan');
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // 3. Menggunakan BottomnavWidget Anda di sini
      bottomNavigationBar: BottomnavWidget(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}