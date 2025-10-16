import 'package:b25_pg011_capstone_project/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _auth = AuthService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _has8Characters = false;
  bool _hasSymbolAndNumber = false;
  bool _hasCapitalLetter = false;

  void _onPasswordChanged(String password) {
    setState(() {
      _has8Characters = password.length >= 8;
      _hasSymbolAndNumber = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) && password.contains(RegExp(r'[0-9]'));
      _hasCapitalLetter = password.contains(RegExp(r'[A-Z]'));
    });
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

                _buildValidationRow('Password terdiri dari 8 huruf', _has8Characters),
                _buildValidationRow('Password terdiri simbol dan angka', _hasSymbolAndNumber),
                _buildValidationRow('Password terdiri dari Huruf Kapital', _hasCapitalLetter),
                const SizedBox(height: 16),
                
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
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_passwordController.text != _confirmPasswordController.text) {
                        print('Error: Password tidak cocok');
                        return;
                      }

                      if (!_has8Characters || !_hasSymbolAndNumber || !_hasCapitalLetter) {
                        print('Error: Validasi password gagal');
                        return;
                      }
                      
                      final userCredential = await _auth.registerWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                        _nameController.text,
                      );
                      
                      if (userCredential != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B8E23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
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