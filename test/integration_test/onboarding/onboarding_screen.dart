import 'package:b25_pg011_capstone_project/screen/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('menampilkan teks dan tombol di OnboardingScreen', (
    tester,
  ) async {
    // Memuat OnboardingScreen di dalam MaterialApp
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

    // Memastikan teks utama tampil
    expect(find.text('Cerdas Catat, Cerdas Rencana'), findsOneWidget);

    // Memastikan teks deskripsi tampil
    expect(
      find.text(
        'Catat penjualan dan atur keuangan usaha agar berkembang lebih berkelanjutan.',
      ),
      findsOneWidget,
    );

    // Memastikan tombol "Mulai Sekarang" tampil
    expect(find.text('Mulai Sekarang'), findsOneWidget);
  });
}
