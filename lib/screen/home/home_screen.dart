import 'package:b25_pg011_capstone_project/widget/banner_dashboard_widget.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/item_plan_widget.dart';
import 'package:flutter/material.dart';

import '../../style/colors/app_colors.dart';
import '../../widget/banner_cashflow_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final int completed = 2;
    final int total = 5;
    final todos = [
      {
        'department': 'Marketing',
        'task': 'Making 3 Post For Social Media',
        'isDone': false,
      },
      {'department': 'Production', 'task': 'Evaluasi Produk', 'isDone': false},
      {
        'department': 'Finance',
        'task': 'Update Monthly Report',
        'isDone': true,
      },
    ];
    final activeCount = todos.where((t) => t['isDone'] == true).length;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'Hello JohnDoe!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.notifications_outlined, size: 27),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BannerDashboardWidget(
                finishedTask: completed,
                allTask: total,
              ),
            ),
            SizedBox(height: 29),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Keuangan Minggu ini',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: _BannerCashflow(),
            ),
            const SizedBox(height: 29),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "TO DO",
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgPink.colors,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$activeCount',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 12,
                        color: AppColors.textTaskRed.colors,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(child: _TaskListWidget(tasks: todos)),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ButtonWidget(
                key: const Key('tambah_data_button'),
                title: "Tambah Data",
                textColor: AppColors.btnTextWhite.colors,
                foregroundColor: AppColors.bgSoftGreen.colors,
                backgroundColor: AppColors.btnGreen.colors,
                onPressed: () {
                  Navigator.pushNamed(context, '/addTask');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerCashflow extends StatelessWidget {
  const _BannerCashflow();

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

class _TaskListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  const _TaskListWidget({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ItemPlanWidget(
            task: task['task'],
            category: task['department'],
            isChecked: task['isDone'] == true,
            onChange: (bool? value) {},
          );
        },
      ),
    );
  }
}

class _EmptyTaskWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
          "Data Task kamu kosong",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8),
        Text(
          "Tambahkan Task kamu hari ini",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textGrey.colors,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
