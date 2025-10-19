// lib/screen/register/company_profile_screen.dart

import 'package:b25_pg011_capstone_project/widget/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart'; // Pastikan path ini benar

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _companyNameController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _saveCompanyProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in!");
      }

      // Update data di Firestore dengan Company Name dan Position
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'companyName': _companyNameController.text.trim(),
            'position': _positionController.text.trim(),
          });

      // Setelah berhasil, navigasi ke MainScreen (Home)
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacementNamed(NavigationRoute.homeRoute.name);
      }

      // Tampilkan SnackBar sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackbarWidget(
            message: 'Profil perusahaan berhasil disimpan!',
            success: true,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackbarWidget(
            message: 'Gagal menyimpan profil perusahaan!',
            success: false,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Perusahaan"),
        automaticallyImplyLeading: false, // Jangan ada tombol back
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lengkapi Profil Perusahaan Anda",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Mohon masukkan informasi perusahaan dan jabatan Anda.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              _buildTextField(
                controller: _companyNameController,
                labelText: "Nama Perusahaan",
                hintText: "Masukkan Nama Perusahaan Anda",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Perusahaan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _positionController,
                labelText: "Jabatan",
                hintText: "Masukkan Jabatan Anda",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jabatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveCompanyProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Color(0xFF6B8E23),
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Selesai", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }
}
