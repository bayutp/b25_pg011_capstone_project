import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../dummy/register_page_dummy.dart'; // Buat file ini, copy dari RegisterPage asli, ganti import AuthService ke dummy

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterPage Integration Test', () {
    testWidgets('Semua field dan tombol register tampil', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      expect(
        find.byType(TextField),
        findsNWidgets(4),
      ); // Nama, Email, Password, Konfirmasi
      expect(find.text('Register'), findsAtLeastNWidgets(1));
      expect(find.text('Daftar'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Tombol register bisa ditekan dengan data valid', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      await tester.enterText(find.byType(TextField).at(0), 'Nama Dummy');
      await tester.enterText(find.byType(TextField).at(1), 'dummy@email.com');
      await tester.enterText(find.byType(TextField).at(2), 'Password1!');
      await tester.enterText(find.byType(TextField).at(3), 'Password1!');

      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();

      // Karena tidak ada navigasi atau feedback, cek tetap di halaman register
      expect(find.text('Register'), findsAtLeastNWidgets(1));
    });

    testWidgets('Tombol register bisa ditekan dengan data tidak valid', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      await tester.enterText(find.byType(TextField).at(0), 'Nama Dummy');
      await tester.enterText(find.byType(TextField).at(1), 'dummy@email.com');
      await tester.enterText(find.byType(TextField).at(2), 'Password1!');
      await tester.enterText(
        find.byType(TextField).at(3),
        'Password2!',
      ); // Konfirmasi beda

      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();

      // Karena tidak ada navigasi atau feedback, cek tetap di halaman register
      expect(find.text('Register'), findsAtLeastNWidgets(1));
    });
  });
}
