import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../dummy/login_page_dummy.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('LoginPage Integration Test', () {
    testWidgets('Semua field dan tombol login tampil', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.byKey(const Key('login_email_field')), findsOneWidget);
      expect(find.byKey(const Key('login_password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      // Cek minimal ada 1 widget dengan text 'Login'
      expect(find.text('Login'), findsAtLeastNWidgets(1));
    });

    testWidgets('Tombol login bisa ditekan dengan data dummy', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'test@email.com',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'Password1!',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Karena tidak ada navigasi atau feedback, cek tetap di halaman login
      expect(find.text('Login'), findsAtLeastNWidgets(1));
    });

    testWidgets('Tombol login bisa ditekan dengan data salah', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'salah@email.com',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'salahpassword',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Karena tidak ada navigasi atau feedback, cek tetap di halaman login
      expect(find.text('Login'), findsAtLeastNWidgets(1));
    });
  });
}
