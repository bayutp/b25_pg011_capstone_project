import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/banner_plan_widget.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/item_plan_widget.dart';
import 'package:flutter/material.dart';

class PlanDetailScreen extends StatelessWidget {
  final String planTitle;
  const PlanDetailScreen({super.key, required this.planTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planTitle, style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            children: [
              _PlanListWidget(),
              const SizedBox(height: 60),
              _StatusTaskWidget(),
              const SizedBox(height: 35),
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
  const _PlanListWidget();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> plan = {
      "category": "Marketing",
      "finisedTask": 12,
      "allTask": 20,
    };
    return SizedBox(
      height: 156,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BannerPlanWidget(
          category: plan['category'],
          finishedTask: 12,
          allTask: 20,
          onTap: () {},
        ),
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
  const _TaskListWidget();

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
