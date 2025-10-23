import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:b25_pg011_capstone_project/screen/cashflow/cashflow_screen.dart';
import 'package:b25_pg011_capstone_project/screen/cashflow/add/add_cashflow_screen.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/transaction_type_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Navigasi dari CashflowScreen ke AddCashflowScreen dan cek field',
    (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TransactionTypeProvider()),
            // Tambahkan provider lain jika AddCashflowScreen butuh
          ],
          child: MaterialApp(
            home: const CashflowScreen(),
            routes: {
              NavigationRoute.addCashflow.name: (context) =>
                  const AddCashflowScreen(),
            },
          ),
        ),
      );

      final tambahDataButton = find.byKey(const Key('tambah_data_button'));
      await tester.ensureVisible(tambahDataButton);
      await tester.tap(tambahDataButton);
      await tester.pumpAndSettle();

      expect(find.text('Tambah Data Cash flow'), findsOneWidget);
      expect(find.text('Jenis'), findsOneWidget);
      expect(find.text('Pilih Tanggal'), findsOneWidget);
      expect(find.text('Total Pengeluaran'), findsOneWidget);
      expect(find.text('Keterangan'), findsOneWidget);
      expect(find.text('Tambahkan Data'), findsOneWidget);
    },
  );
}
