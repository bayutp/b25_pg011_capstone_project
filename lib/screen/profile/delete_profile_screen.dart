import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Untuk menjalankan contoh ini secara mandiri
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contoh Hapus Akun',
      theme: ThemeData(
        // Menggunakan warna dari AppColors sebagai tema utama
        primaryColor: AppColors.btnGreen.colors,
        scaffoldBackgroundColor: AppColors.bgWhite.colors,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgWhite.colors,
          elevation: 0,
          foregroundColor: AppColors.textBlack.colors, // Warna ikon dan teks
        ),
      ),
      home: const DeleteProfileScreen(),
    );
  }
}

// Ini adalah screen utama yang sudah direvisi
class DeleteProfileScreen extends StatelessWidget {
  const DeleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hapus Akun',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack.colors,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teks Peringatan (bold-nya sudah beneran ya pakai RichText)
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppColors.textBlack.colors,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text:
                        'Dengan melanjutkan proses ini, Anda mengerti dan setuju bahwa semua data Anda, termasuk profil, riwayat, dan informasi lainnya akan ',
                  ),
                  TextSpan(
                    text: 'dihapus secara permanen ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ), // Ini yang membuat tebal
                  ),
                  TextSpan(
                    text:
                        'dan tidak dapat dipulihkan. Anda bertanggung jawab penuh atas tindakan ini.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32), // Jarak antara teks dan tombol
            // Tombol Hapus Akun (selalu aktif)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnGreen.colors, // Warna tombol
                foregroundColor:
                    AppColors.btnTextWhite.colors, // Warna teks tombol
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Langsung panggil fungsi karena tidak ada checkbox
              onPressed: () async {
                showAppConfirmationDialog(
                  context: context,
                  title: 'Hapus akun',
                  content: 'Apakah anda yakin ingin menghapus akun ini?',
                  confirmButtonText: 'Ya, Saya yakin',
                  cancelButtonText: 'Batal',
                  onConfirm: () async {
                    final service = context.read<AuthService>();

                    try {
                      // 2. Panggil fungsi hapus akun dan tunggu sampai selesai
                      await service.deleteAccount();

                      // 3. Jika berhasil, tampilkan pesan sukses dan navigasi ke halaman login
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Akun Anda berhasil dihapus.'),
                            backgroundColor: Colors
                                .green, // atau AppColors.snackbarSuccess.colors
                          ),
                        );
                        Navigator.popAndPushNamed(
                          context,
                          NavigationRoute.loginRoute.name,
                        );
                      }
                    } catch (e) {
                      // 4. Jika gagal, tangkap error dan tampilkan pesannya ke pengguna
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors
                                .red, // atau AppColors.snackbarFailed.colors
                          ),
                        );
                      }
                    }
                  },
                );
              },
              child: const Text('Hapus Akun Saya'),
            ),
          ],
        ),
      ),
    );
  }
}
