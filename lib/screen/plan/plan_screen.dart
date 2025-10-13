import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/banner_plan_widget.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/date_picker_widget.dart';
import 'package:b25_pg011_capstone_project/widget/item_plan_widget.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // _EmptyPlanWidget(),
              _PlanListWidget(),
              const SizedBox(height: 39),
              _TotalTaskWidget(),
              const SizedBox(height: 28),
              _DatePickerWidget(),
              const SizedBox(height: 35),
              _StatusTaskWidget(),
              const SizedBox(height: 28),
              // _EmptyTaskWidget(),
              _TaskListWidget(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ButtonWidget(
                  key: const Key('tambah_data_button'),
                  title: "Tambah Data",
                  textColor: AppColors.btnTextWhite.colors,
                  foregroundColor: AppColors.bgSoftGreen.colors,
                  backgroundColor: AppColors.btnGreen.colors,
                  onPressed: () {
                    // Handle button press
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanListWidget extends StatelessWidget {
  const _PlanListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> plans = [
      {"category": "Marketing", "finisedTask": 12, "allTask": 20},
      {"category": "Management", "finisedTask": 3, "allTask": 7},
      {"category": "Sales", "finisedTask": 6, "allTask": 12},
      {"category": "Support", "finisedTask": 2, "allTask": 5},
      {"category": "HR", "finisedTask": 1, "allTask": 4},
      {"category": "Finance", "finisedTask": 7, "allTask": 14},
      {"category": "IT", "finisedTask": 9, "allTask": 18},
    ];
    return SizedBox(
      height: 156,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return BannerPlanWidget(
            category: plan['category'],
            finishedTask: 12,
            allTask: 20,
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _EmptyPlanWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 33),
        decoration: BoxDecoration(
          color: AppColors.bgGrey.colors,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/ic_empty_white.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'Data Category kosong',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey.colors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalTaskWidget extends StatelessWidget {
  const _TotalTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "TO DO",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 16),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.bgPink.colors,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "0",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 12,
                color: AppColors.textTaskRed.colors,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePickerWidget extends StatelessWidget {
  const _DatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DatePickerWidget(
        onDateChange: (date) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected date: $date'),
              backgroundColor: AppColors.snackbarSuccess.colors,
            ),
          );
        },
      ),
    );
  }
}

class _StatusTaskWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DefaultTabController(
        length: 3,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            labelColor: AppColors.bgGreen.colors,
            unselectedLabelColor: Colors.grey[400],
            indicator: BoxDecoration(
              color: AppColors.bgSoftGreen.colors,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelPadding: const EdgeInsets.symmetric(horizontal: 6),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(
                child: Text(
                  "On Progress",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Completed",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Pending",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTaskWidget extends StatelessWidget {
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
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tasks = [
      {
        "category": "Marketing",
        "task": "Making 3 Post For Social Media",
        "done": false,
      },
      {"category": "Management", "task": "Meeting With Team", "done": false},
      {
        "category": "Sales",
        "task": "Contact 10 Prospective Clients",
        "done": false,
      },
      {
        "category": "Support",
        "task": "Respond to Customer Emails",
        "done": false,
      },
      {
        "category": "HR",
        "task": "Organize Team Building Activity",
        "done": false,
      },
      {"category": "Production", "task": "Evaluasi Produk", "done": true},
      {"category": "Finance", "task": "Evaluasi Produk", "done": false},
      {"category": "Inventory", "task": "Evaluasi Produk", "done": false},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ItemPlanWidget(
            task: task['task'],
            category: task['category'],
            isChecked: task['done'],
            onChange: (bool? value) {},
          );
        },
      ),
    );
  }
}
