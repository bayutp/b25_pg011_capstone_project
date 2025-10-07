// integration_test/auth_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

// pakai file UI kamu yang sudah ada (TIDAK diubah)
import 'package:b25_pg011_capstone_project/screen/login/login_pages.dart'; // LoginPage
import 'package:b25_pg011_capstone_project/screen/register/register_page.dart'; // RegisterPage

import '../test/integration_test/firebase_test_setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // seed user utk test login
  const seedEmail = 'seed_login@example.com';
  const seedPassword = 'Password!1A';

  setUpAll(() async {
    await setupFirebaseForTests();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: seedEmail,
        password: seedPassword,
      );
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // kalau sudah ada -> lanjut
    }
  });

  tearDown(() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
  });

  testWidgets('Register: user baru berhasil dibuat & otomatis login', (
    WidgetTester tester,
  ) async {
    final unique = DateTime.now().millisecondsSinceEpoch;
    final email = 'user_$unique@example.com';
    const name = 'Test User';
    const password = 'Password!1A';

    await tester.pumpWidget(const MaterialApp(home: RegisterPage()));
    await tester.pumpAndSettle();

    // 0: Nama, 1: Email, 2: Password, 3: Ketik Ulang Password
    await tester.enterText(find.byType(TextField).at(0), name);
    await tester.enterText(find.byType(TextField).at(1), email);
    await tester.enterText(find.byType(TextField).at(2), password);
    await tester.enterText(find.byType(TextField).at(3), password);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Daftar'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;
    expect(user, isNotNull, reason: 'User harus login setelah register');
    expect(user!.email, email);
  });

  testWidgets('Login: seed user bisa login', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.pumpAndSettle();

    // 0: Email, 1: Password
    await tester.enterText(find.byType(TextField).at(0), seedEmail);
    await tester.enterText(find.byType(TextField).at(1), seedPassword);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;
    expect(user, isNotNull, reason: 'User harus login');
    expect(user!.email, seedEmail);
  });
}
