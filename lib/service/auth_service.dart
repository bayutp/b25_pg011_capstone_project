import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mendaftar dengan email, password, dan username
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data pengguna (username) di Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Registrasi gagal: ${e.message}');
      return null;
    }
  }

  // Fungsi untuk masuk (login)
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Login gagal: ${e.message}');
      return null;
    }
  }

  // Fungsi untuk keluar (logout)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}