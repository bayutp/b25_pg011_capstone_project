import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/data/model/user_plan.dart';
import 'package:b25_pg011_capstone_project/data/model/user_todo.dart';
import 'package:b25_pg011_capstone_project/provider/plan/plan_date_provider.dart';
import 'package:b25_pg011_capstone_project/provider/plan/todo_status_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
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
    final selectedDate = context.watch<PlanDateProvider>().selectedDate;
    final user = context.watch<UserLocalProvider>().userLocal;
    final provider = context.read<TodoStatusProvider>();
    provider.setStatus("on progress");

    return Scaffold(
      appBar: AppBar(
        title: Text("Task", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _PlanWidget(user: user!),
            const SizedBox(height: 39),
            _TotalTaskWidget(selectedDate: selectedDate, user: user),
            const SizedBox(height: 28),
            const _DatePickerWidget(),
            const SizedBox(height: 35),
            _StatusTaskWidget(selectedDate: selectedDate),
            const SizedBox(height: 28),
            _TaskWidget(selectedDate: selectedDate, user: user),
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
                    '/addTask',
                    arguments: {
                      'user': user,
                      'plan': UserPlan(
                        userId: user.uid,
                        businessId: user.idbuz,
                        name: '',
                        planId: '',
                        createdBy: user.uid,
                        createdAt: DateTime.now(),
                      ),
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanWidget extends StatelessWidget {
  final UserLocal user;
  const _PlanWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    final stream = context.read<FirebaseFirestoreService>().getPlansByUserId(
      user.uid,
      user.idbuz,
    );

    return StreamProvider<List<UserPlan>>.value(
      value: stream,
      initialData: const [],
      child: Consumer<List<UserPlan>>(
        builder: (context, plans, child) {
          if (plans.isEmpty) return _EmptyPlanWidget();
          return _PlanListWidget(plans: plans, user: user);
        },
      ),
    );
  }
}

class _TaskWidget extends StatelessWidget {
  final DateTime selectedDate;
  final UserLocal user;
  const _TaskWidget({required this.selectedDate, required this.user});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<TodoStatusProvider>().status;

    final stream = context.read<FirebaseFirestoreService>().getDailyTodos(
      user.idbuz,
      status,
      selectedDate,
    );

    return StreamProvider<List<UserTodo>>.value(
      value: stream,
      initialData: const [],
      child: Consumer<List<UserTodo>>(
        builder: (context, todos, _) {
          if (todos.isEmpty) return _EmptyTaskWidget();
          return _TaskListWidget(tasks: todos);
        },
      ),
    );
  }
}

class _PlanListWidget extends StatelessWidget {
  final List<UserPlan> plans;
  final UserLocal user;
  const _PlanListWidget({required this.plans, required this.user});

  @override
  Widget build(BuildContext context) {
    return plans.length <= 1
        ? SizedBox(
            height: 156,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder(
                stream: context
                    .read<FirebaseFirestoreService>()
                    .getTodosByPlanId(plans.first.planId, user.idbuz),
                builder: (context, asyncSnapshot) {
                  final todos = asyncSnapshot.data ?? [];
                  final finishedTask = todos
                      .where((t) => t.status == "completed")
                      .length;
                  final allTask = todos.length;
                  return BannerPlanWidget(
                    category: plans.first.name,
                    finishedTask: finishedTask,
                    allTask: allTask,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/planDetail',
                        arguments: {'plan': plans.first, 'user': user},
                      );
                    },
                  );
                },
              ),
            ),
          )
        : SizedBox(
            height: 156,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return StreamBuilder<List<UserTodo>>(
                  stream: context
                      .read<FirebaseFirestoreService>()
                      .getTodosByPlanId(plan.planId, user.idbuz),
                  builder: (context, snapshot) {
                    final todos = snapshot.data ?? [];
                    final finishedTask = todos
                        .where((t) => t.status == "completed")
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
                          arguments: {'plan': plan, 'user': user},
                        );
                      },
                    );
                  },
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
  final UserLocal user;
  const _TotalTaskWidget({required this.selectedDate, required this.user});

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
                  user.uid,
                  user.idbuz,
                  selectedDate,
                  "daily",
                );
              },
              initialData: 0,
              catchError: (context, error) {
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
          context.read<TodoStatusProvider>().setStatus("on progress");
        },
      ),
    );
  }
}

class _StatusTaskWidget extends StatefulWidget {
  final DateTime selectedDate;

  const _StatusTaskWidget({required this.selectedDate});

  @override
  State<_StatusTaskWidget> createState() => _StatusTaskWidgetState();
}

class _StatusTaskWidgetState extends State<_StatusTaskWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final status = context.read<TodoStatusProvider>().status;
      tabController.index = _getTabIndexFromStatus(status);
    });

    tabController.addListener(() {
      if (tabController.indexIsChanging) return;
      final provider = context.read<TodoStatusProvider>();
      provider.setStatus(_getStatusFromTabIndex(tabController.index));
    });
  }

  int _getTabIndexFromStatus(String status) {
    switch (status) {
      case "on progress":
        return 0;
      case "completed":
        return 1;
      case "pending":
        return 2;
      default:
        return 0;
    }
  }

  String _getStatusFromTabIndex(int index) {
    switch (index) {
      case 0:
        return "on progress";
      case 1:
        return "completed";
      case 2:
        return "pending";
      default:
        return "on progress";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoStatusProvider>(
      builder: (context, value, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final newIndex = _getTabIndexFromStatus(value.status);
          if (tabController.index != newIndex) {
            tabController.animateTo(newIndex);
          }
        });

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: tabController,
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
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
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
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final isCompleted = task.status == "completed";
          final item = ItemPlanWidget(
            task: task.todo,
            category: task.plan,
            isChecked: task.status == 'completed',
            onChange: (bool? value) async {
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day, 23, 59, 59);

              final newStatus = value == true
                  ? "completed"
                  : task.endDate.isBefore(today)
                  ? "pending"
                  : "on progress";

              await context.read<FirebaseFirestoreService>().updateTodoStatus(
                task.todoId,
                newStatus,
              );
            },
          );
          return isCompleted ? Opacity(opacity: 0.5, child: item) : item;
        },
      ),
    );
  }
}
