// lib/screen/profile/edit_profile_screen.dart

import 'dart:io';

import 'package:b25_pg011_capstone_project/data/api/api_service.dart';
import 'package:b25_pg011_capstone_project/data/model/user_business.dart';
import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_image_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/widget/editable_avatar.dart';
import 'package:b25_pg011_capstone_project/widget/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';

// --- TAMBAHAN ---
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final bool newUser;
  const EditProfileScreen({super.key, required this.newUser});

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
  late AuthService service;
  late UserLocalProvider sp;
  late ApiService apiService;
  late UserImageProvider imgProvider;

  // --- TAMBAHAN: State untuk loading ---
  bool _isLoading = false;
  bool _isDataLoaded = false;
  String _imgUrl = '';

  @override
  void initState() {
    super.initState();
    // --- TAMBAHAN: Panggil fungsi untuk memuat data pengguna ---
    service = context.read<AuthService>();
    sp = context.read<UserLocalProvider>();
    apiService = context.read<ApiService>();
    imgProvider = context.read<UserImageProvider>();
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
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final isHasBuz = await service.hasBusiness();
      final userBuzList = await service.getUserBusiness();
      String buzName = '';
      if (isHasBuz && userBuzList.isNotEmpty) {
        buzName = userBuzList.firstWhere((buz) => buz.isActive == true).name;
      }

      if (doc.exists && mounted) {
        final data = doc.data()!;
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _businessNameController.text = buzName;
        _positionController.text = data['position'] ?? '';
        _imgUrl = data['profileUrl'];
        setState(() => _isDataLoaded = true);
      }
    } catch (e) {
      debugPrint('Error load user data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        final userBuzList = await service.getUserBusiness();
        final userBuz = userBuzList
            .where((buz) => buz.isActive == true)
            .toList();

        final fullname =
            "${_firstNameController.text} ${_lastNameController.text}";

        final path = imgProvider.imagePath ?? "";
        if (path.isNotEmpty) {
          _imgUrl = await apiService.uploadImage(File(path)) ?? "";
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
              'firstName': _firstNameController.text.trim(),
              'lastName': _lastNameController.text.trim(),
              'position': _positionController.text.trim(),
              'profileUrl': _imgUrl,
            });

        if (userBuz.isNotEmpty) {
          await service.updateBuzName(
            userBuz.first.idBusiness,
            user.uid,
            _businessNameController.text,
          );
          sp.setStatusUser(
            UserLocal(
              statusLogin: true,
              statusFirstLaunch: false,
              uid: user.uid,
              idbuz: userBuz.first.idBusiness,
              fullname: fullname,
              imgUrl: _imgUrl,
            ),
          );
        } else {
          final idbuz = await service.addBusiness(
            UserBusiness(
              idOwner: service.uid!,
              name: _businessNameController.text,
              createdAt: DateTime.now(),
            ),
          );
          sp.setStatusUser(
            UserLocal(
              statusLogin: true,
              statusFirstLaunch: false,
              uid: user.uid,
              idbuz: idbuz,
              fullname: fullname,
              imgUrl: _imgUrl,
            ),
          );
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackbarWidget(
              message: "Perubahan berhasil disimpan!",
              success: true,
            ),
          );
          if (widget.newUser) {
            Navigator.pushReplacementNamed(
              context,
              NavigationRoute.homeRoute.name,
            );
          } else {
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackbarWidget(message: "Data gagal disimpan!", success: false),
        );
        debugPrint("error edit profile >> ${e.toString()}");
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
        title: Text(
          "Ubah Profile",
          style: Theme.of(context).textTheme.titleLarge,
        ),
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
                      EditableAvatar(imageUrl: _imgUrl, size: 100),
                      SizedBox(height: 24),
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
