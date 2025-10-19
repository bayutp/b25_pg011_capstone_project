import 'package:b25_pg011_capstone_project/data/model/user_business.dart';
import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/service/sharedpreferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Diperlukan untuk debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedpreferencesService _prefs;

  AuthService(this._prefs);

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

        await _prefs.setStatusUser(
          UserLocal(
            statusLogin: true,
            statusFirstLaunch: false,
            uid: userCredential.user!.uid,
          ),
        );
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
      await _prefs.setStatusUser(
        UserLocal(
          statusLogin: true,
          statusFirstLaunch: false,
          uid: userCredential.user!.uid,
        ),
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

  // Forgot password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Email tidak terdaftar.';
      } else if (e.code == 'invalid-email') {
        throw 'Format email tidak valid.';
      } else {
        throw 'Terjadi kesalahan. Coba lagi nanti.';
      }
    }
  }

  String? get uid => _auth.currentUser?.uid;

  Future<List<UserBusiness>> getUserBusiness() async {
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection("business")
        .where("idOwner", isEqualTo: uid)
        .get();

    return snapshot.docs
        .map((doc) => UserBusiness.fromJson(doc.data()))
        .toList();
  }

  Future<String> getFullname() async {
    if (uid == null) return '';

    final snapshot = await _firestore.collection("users").doc(uid).get();
    if (!snapshot.exists) return '';

    final data = snapshot.data();
    return '${data?['firstName'] ?? ''} ${data?['lastName'] ?? ''}'.trim();
  }

  Future<void> deleteAccount() async {
    try {
      if (uid == null) {
        throw Exception(
          'Tidak ada pengguna yang terautentikasi untuk dihapus.',
        );
      }
      // 1. Ambil user yang sedang login. Jika tidak ada, lempar error.
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception(
          'Tidak ada pengguna yang terautentikasi untuk dihapus.',
        );
      }

      // 2. Siapkan Batch Write untuk menghapus semua data di Firestore secara atomik.
      // Batch Write memastikan semua operasi berhasil atau semua gagal. Mencegah data sampah.
      final batch = _firestore.batch();

      // 3. Cari dan tandai untuk dihapus: semua dokumen 'business' milik pengguna.
      final businessQuery = await _firestore
          .collection('business')
          .where('idOwner', isEqualTo: uid)
          .get();

      for (final doc in businessQuery.docs) {
        batch.delete(doc.reference);
      }

      // 4. Tandai untuk dihapus: dokumen utama pengguna di collection 'users'.
      final userDocRef = _firestore.collection('users').doc(uid);
      batch.delete(userDocRef);

      // 5. Jalankan semua operasi penghapusan data di Firestore.
      await batch.commit();

      // 6. Setelah semua data terhapus, hapus akun dari Firebase Auth.
      await user.delete();

      // 7. (Opsional tapi direkomendasikan) Bersihkan data lokal.
      await _prefs.setStatusUser(
        UserLocal(statusLogin: false, statusFirstLaunch: false, uid: ''),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('FIREBASE AUTH ERROR (DELETE): ${e.code}');
      if (e.code == 'requires-recent-login') {
        throw Exception(
          'Sesi Anda telah berakhir. Silakan login kembali untuk melanjutkan.',
        );
      }
      rethrow; // Lempar kembali error asli jika bukan 'requires-recent-login'
    } catch (e) {
      debugPrint('GENERAL ERROR (DELETE): $e');
      rethrow; // Lempar kembali error agar bisa ditangani di UI
    }
  }

  Future<String> addBusiness(UserBusiness business) async {
    final name = business.name.trim();
    final normalizedName = name.toLowerCase();

    // Cek duplikat nama bisnis milik user
    final querySnapshot = await _firestore
        .collection('business')
        .where('idOwner', isEqualTo: business.idOwner)
        .get();

    final duplicateName = querySnapshot.docs.any((doc) {
      final existingName = (doc.data()['name'] as String).trim().toLowerCase();
      return existingName == normalizedName;
    });

    if (duplicateName) {
      throw Exception('Bisnis dengan nama "${business.name}" sudah ada.');
    }

    // Tambahkan bisnis baru
    final docRef = _firestore.collection("business").doc();
    final buzId = docRef.id;

    await docRef.set({
      ...business.toJson(),
      'idBusiness': buzId,
      'isActive': true,
    });

    // Update status bisnis aktif
    await updateBuzStatus(buzId, business.idOwner);

    return buzId;
  }

  Future<void> updateBuzStatus(String idBusiness, String idUser) async {
    final bizRef = FirebaseFirestore.instance.collection('business');
    final batch = FirebaseFirestore.instance.batch();

    // Nonaktifkan semua bisnis lama milik user
    final currentActive = await bizRef
        .where('idOwner', isEqualTo: idUser)
        .where('isActive', isEqualTo: true)
        .get();

    for (var doc in currentActive.docs) {
      batch.update(doc.reference, {'isActive': false});
    }

    // Aktifkan bisnis baru
    final newBizRef = bizRef.doc(idBusiness);
    batch.update(newBizRef, {'isActive': true});

    await batch.commit();
  }

  Future<void> updateBuzName(
    String idBusiness,
    String idUser,
    String name,
  ) async {
    final docRef = _firestore.collection("business").doc(idBusiness);
    await docRef.update({'name': name});
  }

  Future<bool> hasBusiness() async {
    if (uid == null) return false;

    final snapshot = await _firestore
        .collection('business')
        .where('idOwner', isEqualTo: uid)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
