import 'package:b25_pg011_capstone_project/data/model/user_plan.dart';
import 'package:b25_pg011_capstone_project/data/model/user_todo.dart';
import 'package:b25_pg011_capstone_project/provider/plan/detail_status_provider.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/banner_plan_widget.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/item_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanDetailScreen extends StatelessWidget {
  final UserPlan plan;
  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name, style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            children: [
              _PlanListWidget(plan: plan),
              const SizedBox(height: 60),
              _StatusTaskWidget(),
              const SizedBox(height: 35),
              _TaskWidget(plan: plan),
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
                    Navigator.pushNamed(
                      context,
                      NavigationRoute.addTaskRoute.name,
                    );
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

class _TaskWidget extends StatelessWidget {
  final UserPlan plan;
  const _TaskWidget({required this.plan});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<DetailStatusProvider>().status;
    return StreamProvider<List<UserTodo>>(
      key: ValueKey('plan-$status'),
      create: (context) => context
          .read<FirebaseFirestoreService>()
          .getDetailPlanByStatus(plan.planId, "N9eTsVw6rtKE8eWROmGC", status),
      initialData: const [],
      child: Consumer<List<UserTodo>>(
        builder: (context, todos, _) {
          if (todos.isEmpty) {
            return _EmptyTaskWidget();
          } else {
            return _TaskListWidget(tasks: todos);
          }
        },
      ),
    );
  }
}

class _PlanListWidget extends StatelessWidget {
  final UserPlan plan;
  const _PlanListWidget({required this.plan});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 156,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamProvider<List<UserTodo>>(
          key: ValueKey("plan ${plan.planId}"),
          create: (context) {
            return context.read<FirebaseFirestoreService>().getTodosByPlanId(
              plan.planId,
              "N9eTsVw6rtKE8eWROmGC",
            );
          },
          initialData: const [],
          child: Consumer<List<UserTodo>>(
            builder: (context, value, child) {
              final allTask = value.length;
              final finishedTask = value
                  .where((todo) => todo.status == "completed")
                  .length;
              return BannerPlanWidget(
                category: plan.name,
                finishedTask: finishedTask,
                allTask: allTask,
                onTap: () {},
              );
            },
          ),
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
            onTap: (value) {
              final provider = context.read<DetailStatusProvider>();
              switch (value) {
                case 0:
                  provider.setStatus("on progress");
                case 1:
                  provider.setStatus("completed");
                case 2:
                  provider.setStatus("pending");
                default:
                  provider.setStatus("on progress");
              }
            },
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
  final List<UserTodo> tasks;
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
            task: task.todo,
            category: task.plan,
            isChecked: task.status == "completed",
            onChange: (bool? value) async {
              final newStatus = value == true
                  ? "completed"
                  : task.endDate.isBefore(DateTime.now())
                  ? "pending"
                  : "on progress";
              await context.read<FirebaseFirestoreService>().updateTodoStatus(
                task.todoId,
                newStatus,
              );
            },
          );
        },
      ),
    );
  }
}
