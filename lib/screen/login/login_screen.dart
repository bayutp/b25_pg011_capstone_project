import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Diperlukan untuk FirebaseAuthException
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:b25_pg011_capstone_project/screen/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // State untuk loading

  // Fungsi untuk menampilkan dialog peringatan
  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menangani proses login
  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showAlertDialog('Gagal Login', 'Email dan password tidak boleh kosong.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email,
        password,
      );

      if (userCredential != null) {
        // Navigasi eksplisit ke MainScreen setelah login berhasil
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            NavigationRoute.userCheck.name,
            (route) => false
          );
        }
      } else {
        // Ini mungkin terjadi jika ada masalah jaringan atau service error
        _showAlertDialog(
          'Gagal Login',
          'Terjadi kesalahan. Silakan coba lagi.',
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = 'Email atau password salah. Mohon periksa kembali.';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid.';
          break;
        default:
          errorMessage =
              'Login gagal: ${e.message ?? 'Terjadi kesalahan tak terduga.'}';
      }
      _showAlertDialog('Gagal Login', errorMessage);
    } catch (e) {
      _showAlertDialog(
        'Kesalahan',
        'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          // Tambahkan SingleChildScrollView untuk menghindari overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ), // Jarak dari atas agar tidak terlalu mepet
              // Header
              const Text(
                'Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selamat datang kembali!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan Email Anda',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukkan Password Anda',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 8),

              // Lupa Password?
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showAlertDialog(
                      'Fitur Nonaktif',
                      'Fitur Lupa Password belum diimplementasikan.',
                    );
                  },
                  child: const Text('Lupa Password?'),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B8E23),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Link ke halaman Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Tidak Punya Akun? '),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
