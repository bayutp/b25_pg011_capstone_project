class AuthService {
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    // Dummy logic: hanya email dan password tertentu yang berhasil
    await Future.delayed(const Duration(milliseconds: 100));
    if (email == 'test@email.com' && password == 'Password1!') {
      return true; // login sukses
    }
    return false; // login gagal
  }

  Future<bool> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    // Dummy register selalu sukses
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  Future<void> signOut() async {
    // Dummy sign out
    await Future.delayed(const Duration(milliseconds: 50));
  }
}
