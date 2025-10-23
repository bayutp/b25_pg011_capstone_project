import 'package:b25_pg011_capstone_project/screen/cashflow/add/add_cashflow_screen.dart';
import 'package:b25_pg011_capstone_project/screen/cashflow/cashflow_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:b25_pg011_capstone_project/provider/cashflow/cashflow_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/transaction_type_provider.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/data/model/user_cashflow.dart';
import 'package:b25_pg011_capstone_project/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    final firestore = FirebaseFirestore.instance;

    firestore.useFirestoreEmulator(host, 8080);
    firestore.settings = const Settings(
      host: '10.0.2.2:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );

    debugPrint('✅ Firebase initialized & emulator connected to $host:8080');
  });

  group('💰 Cashflow Firebase Integration Test', () {
    testWidgets(
      '1️⃣ Menambah data cashflow dan memastikan tampil di CashflowScreen',
      (WidgetTester tester) async {
        final firestoreService = FirebaseFirestoreService(
          FirebaseFirestore.instance,
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => CashflowDateProvider()),
              ChangeNotifierProvider(create: (_) => TransactionTypeProvider()),
              Provider<FirebaseFirestoreService>.value(value: firestoreService),
            ],
            child: const MaterialApp(home: AddCashflowScreen()),
          ),
        );

        debugPrint('🔹 Pilih jenis transaksi (radio button)...');
        await tester.tap(find.text('Pemasukan')); // pilih radio income
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        debugPrint('🔹 Isi tanggal manual (bypass date picker)...');
        await tester.enterText(find.byType(TextFormField).first, '01/01/2025');
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        debugPrint('🔹 Isi nominal dan keterangan...');
        await tester.enterText(find.byType(TextFormField).at(1), 'Rp 150000');
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'Testing integration',
        );

        debugPrint('🔹 Simpan data...');
        await tester.tap(find.text('Tambahkan Data'));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        debugPrint('✅ Form disubmit');

        // 🔁 Cek apakah data tersimpan di Firestore (retry beberapa kali)
        bool dataFound = false;
        for (int attempt = 1; attempt <= 5; attempt++) {
          final snapshot = await FirebaseFirestore.instance
              .collection('cashflows')
              .where('note', isEqualTo: 'Testing integration')
              .get();

          debugPrint(
            '🔍 Cek Firestore (attempt $attempt): ${snapshot.docs.length} dokumen',
          );
          if (snapshot.docs.isNotEmpty) {
            for (final doc in snapshot.docs) {
              debugPrint('📄 Dokumen ditemukan: ${doc.data()}');
            }
            dataFound = true;
            break;
          }
          await Future.delayed(const Duration(seconds: 2));
        }

        expect(
          dataFound,
          isTrue,
          reason: '❌ Data cashflow belum tersimpan di Firestore',
        );

        debugPrint('🔹 Membuka CashflowScreen...');
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => CashflowDateProvider()),
              Provider<FirebaseFirestoreService>.value(value: firestoreService),
            ],
            child: const MaterialApp(home: CashflowScreen()),
          ),
        );

        await tester.pumpAndSettle(const Duration(seconds: 5));
        debugPrint('✅ CashflowScreen terbuka');

        expect(find.textContaining('Pemasukan'), findsWidgets);
        expect(find.textContaining('150000'), findsWidgets);
      },
    );

    testWidgets('2️⃣ Hitung total cashflow harian sesuai data Firestore', (
      WidgetTester tester,
    ) async {
      final firestoreService = FirebaseFirestoreService(
        FirebaseFirestore.instance,
      );
      final now = DateTime.now();

      // Tambah data dummy
      await firestoreService.addCashflow(
        UserCashflow(
          businessId: "N9eTsVw6rtKE8eWROmGC",
          userId: "RJve4BfErDZNfASQl7OTbRiVAqg1",
          amount: 100000,
          type: "income",
          note: "test income",
          date: now,
          createdBy: "tester",
          createdAt: now,
        ),
      );

      await firestoreService.addCashflow(
        UserCashflow(
          businessId: "N9eTsVw6rtKE8eWROmGC",
          userId: "RJve4BfErDZNfASQl7OTbRiVAqg1",
          amount: 50000,
          type: "expense",
          note: "test expense",
          date: now,
          createdBy: "tester",
          createdAt: now,
        ),
      );

      final incomeStream = firestoreService.getTotalCashflowByType(
        "RJve4BfErDZNfASQl7OTbRiVAqg1",
        "N9eTsVw6rtKE8eWROmGC",
        now,
        "daily",
        "income",
      );

      final expenseStream = firestoreService.getTotalCashflowByType(
        "RJve4BfErDZNfASQl7OTbRiVAqg1",
        "N9eTsVw6rtKE8eWROmGC",
        now,
        "daily",
        "expense",
      );

      final income = await incomeStream.first;
      final expense = await expenseStream.first;

      debugPrint('💵 Income: $income | Expense: $expense');

      expect(income, greaterThanOrEqualTo(100000));
      expect(expense, greaterThanOrEqualTo(50000));
    });
  });
}
