import 'package:b25_pg011_capstone_project/data/model/user_cashflow.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/cashflow_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/cashflow_provider.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/user_income_providers.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final date = DateTime.now();
      context.read<CashflowDateProvider>().setSelectedDate(date);
      context.read<CashflowProvider>().listenCashflow(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CashflowDateProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Cash Flow",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    NavigationRoute.casflowHistoryRoute.name,
                  );
                },
                icon: Icon(Icons.history_rounded, size: 27),
              ),
            ],
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
                  _BannerCashflow(),
                  SizedBox(height: 29),
                  _TotalCashflowWidget(),
                  SizedBox(height: 16),
                  _CashflowWidget(),
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
  const _TotalCashflowWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<CashflowProvider>(
      builder: (context, value, child) => Padding(
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
                value.cashflowCount.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 12,
                  color: AppColors.textTaskRed.colors,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CashflowWidget extends StatelessWidget {
  const _CashflowWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<CashflowProvider>(
      builder: (context, value, child) {
        return value.cashflows.isEmpty
            ? _EmptyCashflow()
            : _CashflowList(cashflows: value.cashflows);
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
              showCashflowDetailDialog(context, cashflow);
            },
          );
        },
      ),
    );
  }

  void showCashflowDetailDialog(BuildContext context, UserCashflow cashflow) {
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
                      cashflow.type == "income" ? "Pemasukan" : "Pengeluaran",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Nominal
                Text(
                  Helper.formatCurrency(cashflow.amount),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Tanggal',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  Helper.formatDate(cashflow.date, withTime: true),
                  style: TextStyle(fontSize: 14),
                ),

                SizedBox(height: 16),

                // Keterangan
                Text(
                  'Keterangan',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(cashflow.note, style: TextStyle(fontSize: 14)),
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
        context.read<CashflowProvider>().listenCashflow(date);
      },
    );
  }
}

class _BannerCashflow extends StatelessWidget {
  const _BannerCashflow();

  @override
  Widget build(BuildContext context) {
    final incomeProvider = context.watch<UserIncomeProvider>();
    return Column(
      children: [
        BannerCashflowWidget(
          title: "Omset Bulan ini",
          money: incomeProvider.userBalance.toInt(),
          color: AppColors.bgPink.colors,
          imgAssets: "assets/img/ic_omset.png",
          isIncome: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: BannerCashflowWidget(
                title: "Pemasukan",
                money: incomeProvider.userIncome.toInt(),
                color: AppColors.bgSoftGreen.colors,
                imgAssets: "assets/img/ic_in.png",
              ),
            ),
            Expanded(
              child: BannerCashflowWidget(
                title: "Pengeluaran",
                money: incomeProvider.userExpense.toInt(),
                color: AppColors.bgCream.colors,
                imgAssets: "assets/img/ic_out.png",
              ),
            ),
          ],
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
