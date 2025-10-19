import 'package:b25_pg011_capstone_project/data/model/user_cashflow.dart';
import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/cashflow_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../static/helper.dart';
import '../../style/colors/app_colors.dart';
import '../../widget/banner_cashflow_widget.dart';
import '../../widget/date_picker_widget.dart';
import '../../widget/item_cashflotw_widget.dart';

class CashflowScreen extends StatefulWidget {
  const CashflowScreen({super.key});

  @override
  State<CashflowScreen> createState() => _CashflowScreenState();
}

class _CashflowScreenState extends State<CashflowScreen> {
  late UserLocal? user;
  @override
  void initState() {
    super.initState();

    user = context.read<UserLocalProvider>().userLocal;
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Consumer<CashflowDateProvider>(
      builder: (context, value, child) {
        final selectedDate = value.selectedDate;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Cash Flow",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Column(
                children: [
                  _DatePicker(),
                  SizedBox(height: 29),
                  _BannerCashflow(
                    key: ValueKey("${selectedDate}banner"),
                    selectedDate: selectedDate,
                    user: user!,
                  ),
                  SizedBox(height: 29),
                  _TotalCashflowWidget(
                    key: ValueKey("${selectedDate}total"),
                    selectedDate: selectedDate,
                    user: user!,
                  ),
                  SizedBox(height: 16),
                  _CashflowWidget(
                    key: ValueKey("${selectedDate}list"),
                    selectedDate: selectedDate,
                    user: user!,
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ButtonWidget(
                      key: const Key('tambah_data_button'),
                      title: "Tambah Data",
                      textColor: AppColors.btnTextWhite.colors,
                      foregroundColor: AppColors.bgSoftGreen.colors,
                      backgroundColor: AppColors.btnGreen.colors,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          NavigationRoute.addCashflow.name,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TotalCashflowWidget extends StatelessWidget {
  final DateTime selectedDate;
  final UserLocal user;
  const _TotalCashflowWidget({
    super.key,
    required this.selectedDate,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<int>(
      create: (context) => context
          .read<FirebaseFirestoreService>()
          .getCountCashflow(user.uid, user.idbuz, selectedDate, "daily"),
      initialData: 0,
      catchError: (context, error) {
        return 0;
      },
      builder: (context, child) {
        final totalCashflow = Provider.of<int>(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "List Cashflow",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgPink.colors, // background badge
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  totalCashflow.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 12,
                    color: AppColors.textTaskRed.colors,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CashflowWidget extends StatelessWidget {
  final DateTime selectedDate;
  final UserLocal user;
  const _CashflowWidget({
    super.key,
    required this.selectedDate,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserCashflow>>(
      create: (context) => context
          .read<FirebaseFirestoreService>()
          .getCashflowsByDate(user.uid, user.idbuz, selectedDate, "daily"),
      initialData: const [],
      catchError: (context, error) {
        return [];
      },
      builder: (context, child) {
        final cashflows = Provider.of<List<UserCashflow>>(context);
        if (cashflows.isEmpty) {
          return const _EmptyCashflow();
        } else {
          return _CashflowList(cashflows: cashflows);
        }
      },
    );
  }
}

class _CashflowList extends StatelessWidget {
  final List<UserCashflow> cashflows;

  const _CashflowList({required this.cashflows});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cashflows.length,
        itemBuilder: (context, index) {
          final cashflow = cashflows[index];
          return ItemCashflotwWidget(
            money: cashflow.amount,
            title: cashflow.type == "income" ? "Pemasukan" : "Pengeluaran",
            onTap: () {
              showCashflowDetailDialog(
                context,
                cashflow.type == "income" ? "Pemasukan" : "Pengeluaran",
                cashflow.amount,
                cashflow.note,
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

class _DatePicker extends StatelessWidget {
  const _DatePicker();

  @override
  Widget build(BuildContext context) {
    return DatePickerWidget(
      onDateChange: (date) {
        context.read<CashflowDateProvider>().setSelectedDate(date);
      },
    );
  }
}

class _BannerCashflow extends StatelessWidget {
  final DateTime selectedDate;
  final UserLocal user;
  const _BannerCashflow({
    super.key,
    required this.selectedDate,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: StreamProvider<num>(
            create: (context) =>
                context.read<FirebaseFirestoreService>().getTotalCashflowByType(
                  user.uid,
                  user.idbuz,
                  selectedDate,
                  "daily",
                  "income",
                ),
            initialData: 0,
            catchError: (context, error) {
              return 0;
            },
            builder: (context, child) {
              final totalIncome = Provider.of<num>(context);
              return BannerCashflowWidget(
                title: "Pemasukan",
                money: totalIncome.toInt(),
                color: AppColors.bgSoftGreen.colors,
                imgAssets: "assets/img/ic_in.png",
              );
            },
          ),
        ),
        Expanded(
          child: StreamProvider<num>(
            create: (context) =>
                context.read<FirebaseFirestoreService>().getTotalCashflowByType(
                  user.uid,
                  user.idbuz,
                  selectedDate,
                  "daily",
                  "expense",
                ),
            initialData: 0,
            catchError: (context, error) {
              return 0;
            },
            builder: (context, child) {
              final totalExpense = Provider.of<num>(context);
              return BannerCashflowWidget(
                title: "Pengeluaran",
                money: totalExpense.toInt(),
                color: AppColors.bgCream.colors,
                imgAssets: "assets/img/ic_out.png",
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyCashflow extends StatelessWidget {
  const _EmptyCashflow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/img/ic_empty.png",
            width: 81,
            height: 81,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 36),
          Text(
            "Data Cashflow kamu kosong",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            "Tambahkan Cashflow kamu hari ini",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textGrey.colors,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
