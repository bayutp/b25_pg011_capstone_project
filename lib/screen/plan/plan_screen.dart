import 'package:b25_pg011_capstone_project/data/model/user_plan.dart';
import 'package:b25_pg011_capstone_project/data/model/user_todo.dart';
import 'package:b25_pg011_capstone_project/provider/plan/plan_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/todo_status_provider.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/banner_plan_widget.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/date_picker_widget.dart';
import 'package:b25_pg011_capstone_project/widget/item_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanDateProvider>(
      builder: (context, value, child) {
        final selectedDate = value.selectedDate;
        return Scaffold(
          appBar: AppBar(
            title: Text("Task", style: Theme.of(context).textTheme.titleLarge),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _PlanWidget(),
                  const SizedBox(height: 39),
                  _TotalTaskWidget(
                    key: ValueKey("totalTask"),
                    selectedDate: selectedDate,
                  ),
                  const SizedBox(height: 28),
                  _DatePickerWidget(),
                  const SizedBox(height: 35),
                  _StatusTaskWidget(
                    key: ValueKey("todoStatus"),
                    selectedDate: selectedDate,
                  ),
                  const SizedBox(height: 28),
                  _TaskWidget(
                    key: ValueKey("todos"),
                    selectedDate: selectedDate,
                  ),
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
                        Navigator.pushNamed(context, '/addTask');
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

class _PlanWidget extends StatelessWidget {
  const _PlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserPlan>>(
      create: (context) =>
          context.read<FirebaseFirestoreService>().getPlansByUserId(
            "RJve4BfErDZNfASQl7OTbRiVAqg1",
            "N9eTsVw6rtKE8eWROmGC",
          ),
      initialData: const [],
      child: Consumer<List<UserPlan>>(
        builder: (context, plans, child) {
          if (plans.isEmpty) {
            return _EmptyPlanWidget();
          } else {
            return _PlanListWidget(key: ValueKey("planning"), plans: plans);
          }
        },
      ),
    );
  }
}

class _TaskWidget extends StatelessWidget {
  final DateTime selectedDate;
  const _TaskWidget({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<TodoStatusProvider>().status;
    final date = context.watch<PlanDateProvider>().selectedDate;

    return StreamProvider<List<UserTodo>>(
      key: ValueKey('${status}_${date.toIso8601String()}'),
      create: (context) => context
          .read<FirebaseFirestoreService>()
          .getDailyTodos("N9eTsVw6rtKE8eWROmGC", status, date),
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
  final List<UserPlan>? plans;
  const _PlanListWidget({super.key, this.plans});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 156,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: plans?.length ?? 0,
        itemBuilder: (context, index) {
          final plan = plans![index];
          return StreamProvider<List<UserTodo>>(
            create: (context) {
              return context.read<FirebaseFirestoreService>().getTodosByPlanId(
                plan.planId,
                "N9eTsVw6rtKE8eWROmGC",
              );
            },
            initialData: const [],
            child: Consumer<List<UserTodo>>(
              builder: (context, value, child) {
                final todos = value;
                final finishedTask = todos
                    .where((todo) => todo.status == "completed")
                    .length;
                final allTask = todos.length;
                return BannerPlanWidget(
                  category: plan.name,
                  finishedTask: finishedTask,
                  allTask: allTask,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/planDetail',
                      arguments: plan.name,
                    );
                  },
                );
              },
            ),
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
  final DateTime selectedDate;
  const _TotalTaskWidget({super.key, required this.selectedDate});

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
            child: StreamProvider<int>(
              key: ValueKey(selectedDate),
              create: (context) {
                return context.read<FirebaseFirestoreService>().countDailyTodos(
                  "RJve4BfErDZNfASQl7OTbRiVAqg1",
                  "N9eTsVw6rtKE8eWROmGC",
                  selectedDate,
                  "daily",
                );
              },
              initialData: 0,
              catchError: (context, error) {
                debugPrint('Error fetching todos: $error');
                return 0;
              },
              builder: (context, child) {
                final provider = Provider.of<int>(context);
                return Text(
                  provider.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 12,
                    color: AppColors.textTaskRed.colors,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePickerWidget extends StatelessWidget {
  const _DatePickerWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DatePickerWidget(
        onDateChange: (date) {
          final provider = context.read<PlanDateProvider>();
          provider.setSelectedDate(date);

          final currentStatus = context.read<TodoStatusProvider>().status;
          context.read<TodoStatusProvider>().setStatus(currentStatus);
        },
      ),
    );
  }
}

class _StatusTaskWidget extends StatelessWidget {
  final DateTime selectedDate;

  const _StatusTaskWidget({super.key, required this.selectedDate});

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
              final provider = context.read<TodoStatusProvider>();
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
  const _TaskListWidget({super.key, required this.tasks});

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
            isChecked: task.status == 'completed',
            onChange: (bool? value) {},
          );
        },
      ),
    );
  }
}
