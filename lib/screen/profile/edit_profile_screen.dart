// lib/screen/profile/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';

// --- TAMBAHAN ---
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey =
      GlobalKey<FormState>(); // --- TAMBAHAN: Kunci untuk validasi ---
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  // --- TAMBAHAN: State untuk loading ---
  bool _isLoading = false;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    // --- TAMBAHAN: Panggil fungsi untuk memuat data pengguna ---
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  // --- TAMBAHAN: Fungsi untuk memuat data dari Firestore ke dalam form ---
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists && mounted) {
          final data = doc.data()!;
          _firstNameController.text = data['firstName'] ?? '';
          _lastNameController.text = data['lastName'] ?? '';
          _businessNameController.text = data['companyName'] ?? '';
          _positionController.text = data['position'] ?? '';
          setState(() {
            _isDataLoaded = true;
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- TAMBAHAN: Fungsi untuk menyimpan perubahan ke Firestore ---
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
              'firstName': _firstNameController.text.trim(),
              'lastName': _lastNameController.text.trim(),
              'companyName': _businessNameController.text.trim(),
              'position': _positionController.text.trim(),
            });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Perubahan berhasil disimpan!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(
            context,
          ).pop(true); // Kirim 'true' untuk menandakan ada perubahan
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menyimpan: $e"),
            backgroundColor: Colors.red,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        // ... (AppBar-mu sudah bagus) ...
      ),
      // --- PERUBAHAN: Tampilkan loading jika data awal belum termuat ---
      body: _isLoading && !_isDataLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                // --- PERUBAHAN: Bungkus dengan Form ---
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Nama Depan',
                              hint: 'Nama depan',
                              controller: _firstNameController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              label: 'Nama Belakang',
                              hint: 'Nama belakang',
                              controller: _lastNameController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        label: 'Nama Usaha / Jasa',
                        hint: 'Masukan Usaha',
                        controller: _businessNameController,
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        label: 'Posisi',
                        hint: 'Masukan Posisi',
                        controller: _positionController,
                      ),
                      const SizedBox(height: 40),
                      // --- PERUBAHAN: Hubungkan tombol ke fungsi _saveChanges ---
                      ButtonWidget(
                        title: 'Simpan Perubahan',
                        onPressed: () => _saveChanges(),
                        isLoading: _isLoading, // Gunakan fungsi _saveChanges
                        backgroundColor: const Color(0xFF546E41),
                        foregroundColor: Colors.white.withOpacity(0.8),
                        textColor: Colors.white,
                        // --- TAMBAHAN: Tampilkan loading di tombol ---
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // --- PERUBAHAN: Tambahkan validasi ke TextFormField ---
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          // Ganti dari TextField ke TextFormField
          controller: controller,
          decoration: InputDecoration(
            // ... (Dekorasimu sudah bagus) ...
          ),
          // --- TAMBAHAN: Validasi sederhana ---
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Field ini tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }
}
