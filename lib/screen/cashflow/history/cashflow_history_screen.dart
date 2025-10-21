import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/static/helper.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CashflowHistoryScreen extends StatelessWidget {
  const CashflowHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.read<FirebaseFirestoreService>();
    final sp = context.read<UserLocalProvider>();
    final uid = sp.userLocal?.uid ?? "";
    final idBuz = sp.userLocal?.idbuz ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cashflow History',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: StreamBuilder(
        stream: service.getCashflowsByDate(
          uid,
          idBuz,
          DateTime.now(),
          "monthly",
        ),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackbarWidget(message: Helper.errMsg, success: false),
              );
            });
            return Center(
              child: Text(
                'Terjadi kesalahan saat memuat data.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          final cashflows = asyncSnapshot.data ?? [];

          if (cashflows.isEmpty) {
            return Center(
              child: Text(
                'No cashflow history available.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return ListView.separated(
            itemCount: cashflows.length,
            separatorBuilder: (_, _) =>
                Divider(height: 1, color: AppColors.bgGrey.colors),
            itemBuilder: (context, index) {
              final n = cashflows[index];
              return ListTile(
                contentPadding: EdgeInsets.all(8),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: n.type == "income"
                      ? AppColors.bgBlue.colors
                      : AppColors.bgCream.colors,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Image.asset(
                      n.type == "income"
                          ? "assets/img/ic_in.png"
                          : "assets/img/ic_out.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Text(
                  n.type == "income" ? "Pemasukan" : "Pengeluaran",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Helper.formatCurrency(n.amount),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      n.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'Inter'),
                    ),
                  ],
                ),
                trailing: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    Helper.formatTime(n.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                onTap: () {
                  final cashflow = cashflows[index];
                  showCashflowDetailDialog(
                    context,
                    cashflow.type == "income" ? "Pemasukan" : "Pengeluaran",
                    cashflow.date,
                    cashflow.amount,
                    cashflow.note,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void showCashflowDetailDialog(
    BuildContext context,
    String title,
    DateTime date,
    num expense,
    String notes,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Cashflow',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Jenis Cashflow
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: AppColors.bgGreen.colors,
                    ),
                    SizedBox(width: 6),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Nominal
                Text(
                  Helper.formatCurrency(expense),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
                SizedBox(height: 16),

                // Keterangan
                Text(
                  'Tanggal :',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  Helper.formatDate(date, withTime: true),
                  style: TextStyle(fontSize: 14),
                ),

                SizedBox(height: 16),
                // Keterangan
                Text(
                  'Keterangan :',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(notes, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
