// lib/screen/register/register_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _auth = AuthService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false; // State untuk loading

  bool _has8Characters = false;
  bool _hasSymbolAndNumber = false;
  bool _hasCapitalLetter = false;

  @override
  void dispose() {
    // Wajib: Hapus controllers saat widget dihapus (agar tidak terjadi memory leak)
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String password) {
    setState(() {
      _has8Characters = password.length >= 8;
      _hasSymbolAndNumber = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) && password.contains(RegExp(r'[0-9]'));
      _hasCapitalLetter = password.contains(RegExp(r'[A-Z]'));
    });
  }

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

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // --- Validasi Input ---
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showAlertDialog('Gagal Daftar', 'Semua kolom wajib diisi.');
      return;
    }

    if (password != confirmPassword) {
      _showAlertDialog('Gagal Daftar', 'Password dan konfirmasi password tidak cocok.');
      return;
    }

    if (!_has8Characters || !_hasSymbolAndNumber || !_hasCapitalLetter) {
      _showAlertDialog('Gagal Daftar', 'Password Anda tidak memenuhi semua kriteria keamanan.');
      return;
    }
    
    // Mulai loading
    setState(() { _isLoading = true; });

    try {
      final userCredential = await _auth.registerWithEmailAndPassword(
        email,
        password,
        name,
      );

      // --- Pengecekan Kunci: if (mounted) ---
      if (userCredential != null && mounted) {
        _showAlertDialog('Berhasil', 'Akun berhasil dibuat. Anda akan diarahkan ke Beranda.');
        
        // Navigasi eksplisit ke MainScreen (homeRoute) dan menghapus semua riwayat.
        Navigator.of(context).pushNamedAndRemoveUntil(
            NavigationRoute.homeRoute.name, 
            (Route<dynamic> route) => false, 
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email ini sudah terdaftar. Silakan login atau gunakan email lain.';
      } else {
        errorMessage = 'Pendaftaran gagal: ${e.message}';
      }
      if (mounted) {
        _showAlertDialog('Gagal Daftar', errorMessage);
      }
    } catch (e) {
      if (mounted) {
        _showAlertDialog('Kesalahan', 'Terjadi kesalahan tidak terduga: ${e.toString()}');
      }
    } finally {
      // Hentikan loading
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Widget _buildValidationRow(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: isValid ? Colors.green : Colors.grey)),
      ],
    );
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pencatatan simpel, perencanaan matang',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Nama Field
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    hintText: 'Masukkan Nama Anda',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

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
                  onChanged: _onPasswordChanged,
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
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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

                // Validasi Password
                _buildValidationRow('Password terdiri dari 8 huruf', _has8Characters),
                _buildValidationRow('Password terdiri simbol dan angka', _hasSymbolAndNumber),
                _buildValidationRow('Password terdiri dari Huruf Kapital', _hasCapitalLetter),
                const SizedBox(height: 16),
                
                // Konfirmasi Password Field
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Ketik Ulang Password',
                    hintText: 'Masukkan Password Anda',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                ),
                const SizedBox(height: 24),
                
                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B8E23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Daftar',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Link ke halaman Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah Punya Akun? '),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}