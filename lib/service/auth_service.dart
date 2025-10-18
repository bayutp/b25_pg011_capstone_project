import 'package:b25_pg011_capstone_project/data/model/user_business.dart';
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
