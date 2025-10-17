import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Diperlukan untuk debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mendaftar dengan penanganan error yang terpisah
  Future<UserCredential?> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    UserCredential? userCredential;

    // 1. Operasi: Membuat Akun (Firebase Auth)
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Menangani kegagalan Auth (misalnya, email sudah digunakan, format salah)
      debugPrint('AUTH ERROR: ${e.code} - ${e.message}');
      rethrow;
    }

    // 2. Operasi: Menyimpan Data Pengguna (Cloud Firestore)
    if (userCredential.user != null) {
      try {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } on FirebaseException catch (e) {
        // Ini menangkap kegagalan Izin/Keamanan Firestore.
        debugPrint('FIRESTORE ERROR (CRITICAL): ${e.code} - ${e.message}');

        // Pilihan: Anda mungkin ingin menghapus akun Auth yang baru dibuat di sini
        // userCredential.user!.delete();

        rethrow; // Mengembalikan null karena pendaftaran data tidak lengkap
      }
    }

    return userCredential;
  }

  // Fungsi untuk masuk (login)
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login gagal: ${e.message}');
      rethrow;
    }
  }

  // Fungsi untuk keluar (logout)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}