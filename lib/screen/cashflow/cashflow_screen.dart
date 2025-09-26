import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:flutter/material.dart';

import '../../static/helper.dart';
import '../../style/colors/app_colors.dart';
import '../../widget/banner_cashflow_widget.dart';
import '../../widget/date_picker_widget.dart';
import '../../widget/item_cashflotw_widget.dart';
import '../../widget/snackbar_widget.dart';

class CashflowScreen extends StatelessWidget {
  const CashflowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Flow", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              _DatePicker(),
              SizedBox(height: 29),
              _BannerCashflow(),
              SizedBox(height: 29),
              Padding(
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
                        '0',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 12,
                          color: AppColors.textTaskRed.colors,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _CashflowList(),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ButtonWidget(
                  title: "Tambah Data",
                  textColor: AppColors.btnTextWhite.colors,
                  foregroundColor: AppColors.bgSoftGreen.colors,
                  backgroundColor: AppColors.btnGreen.colors,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CashflowList extends StatelessWidget {
  final List<Map<String, dynamic>> cashflows = [
    {"title": "Pengeluaran", "money": 5000},
    {"title": "Pemasukan", "money": 10000},
    {"title": "Pengeluaran", "money": 5000},
  ];

  _CashflowList({super.key});

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
            money: cashflow["money"],
            title: cashflow["title"],
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(cashflow["title"])));
            },
          );
        },
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return DatePickerWidget(
      onDateChange: (date) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackbarWidget(
            message: "Selected date: ${Helper.formatDate(date)}",
            success: false,
            icon: Icons.cancel,
          ),
        );
      },
    );
  }
}

class _BannerCashflow extends StatelessWidget {
  const _BannerCashflow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: BannerCashflowWidget(
            title: "Pemasukan",
            money: 0,
            color: AppColors.bgBlue.colors,
            imgAssets: "assets/img/ic_in.png",
          ),
        ),
        Expanded(
          child: BannerCashflowWidget(
            title: "Pengeluaran",
            money: 0,
            color: AppColors.bgCream.colors,
            imgAssets: "assets/img/ic_out.png",
          ),
        ),
      ],
    );
  }
}

class _EmptyCashflow extends StatelessWidget {
  const _EmptyCashflow({super.key});

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
