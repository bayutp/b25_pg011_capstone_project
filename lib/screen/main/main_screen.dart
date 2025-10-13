import 'package:b25_pg011_capstone_project/provider/main/bottomnav_provider.dart';
import 'package:b25_pg011_capstone_project/screen/cashflow/cashflow_screen.dart';
import 'package:b25_pg011_capstone_project/screen/home/home_screen.dart';
import 'package:b25_pg011_capstone_project/screen/plan/plan_screen.dart';
import 'package:b25_pg011_capstone_project/screen/profile/profile_screen.dart';
import 'package:b25_pg011_capstone_project/widget/bottomnav_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart'; // Wajib: Import NavigationRoute
import 'package:b25_pg011_capstone_project/screen/login/login_screen.dart'; // Wajib: Import LoginScreen

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Tampilkan dialog konfirmasi (Opsional namun disarankan untuk UX)
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      final authService = AuthService();
      await authService.signOut();
      
      // Navigasi Eksplisit: Pindah ke LoginScreen dan hapus semua riwayat (MainScreen)
      Navigator.of(context).pushNamedAndRemoveUntil(
        NavigationRoute.loginRoute.name, // Menggunakan rute login
        (Route<dynamic> route) => false, // Menghapus semua halaman di belakang
      );
    }
  }

  // Menentukan judul AppBar berdasarkan index BottomNav
  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Beranda';
      case 1:
        return 'Rencana Keuangan';
      case 2:
        return 'Arus Kas';
      case 3:
        return 'Profil';
      default:
        return 'Capstone Project';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomnavProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_getAppBarTitle(navProvider.getIndex)),
            centerTitle: true,
            actions: [
              // Tombol Logout
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _handleLogout(context), // Memanggil fungsi logout yang baru
              ),
              const SizedBox(width: 8),
            ],
          ),
          // --- Konten Body ---
          body: switch (navProvider.getIndex) {
            0 => const HomeScreen(),
            1 => const PlanScreen(),
            2 => const CashflowScreen(),
            _ => const ProfileScreen(),
          },
          // --- Bottom Navigation Bar ---
          bottomNavigationBar: BottomnavWidget(
            currentIndex: navProvider.getIndex,
            onTap: (index) {
              navProvider.setIndex = index;
            },
          ),
        );
      },
    );
  }
}