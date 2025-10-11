import 'package:b25_pg011_capstone_project/screen/profile/edit_profile_screen.dart';
import 'package:b25_pg011_capstone_project/widget/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:b25_pg011_capstone_project/widget/cardbutton_widget.dart';
import 'package:b25_pg011_capstone_project/widget/bottomnav_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=johndoe'),
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

              CardButtonWidget(
                title: 'Ubah Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );
                },
              ),
              const SizedBox(height: 15),
              CardButtonWidget(
                title: 'Hapus Akun',
                onPressed: () {
                  showAppConfirmationDialog(
                    context: context,
                    title: 'Hapus Akun',
                    content: 'Anda yakin ingin menghapus akun ini?',
                    confirmButtonText: 'Saya Yakin!',
                    cancelButtonText: 'Batal',
                    onConfirm: () {
                      print('Akun dihapus!');
                    },
                  );
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
                    onConfirm: () {
                      print('User logout!');
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}