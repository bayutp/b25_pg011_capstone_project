import 'package:b25_pg011_capstone_project/data/model/user_todo.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/widget/banner_dashboard_widget.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/item_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../style/colors/app_colors.dart';
import '../../widget/banner_cashflow_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserLocalProvider sp;

  @override
  void initState() {
    super.initState();
    sp = context.read<UserLocalProvider>();
    sp.getStatusUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserLocalProvider>(
      builder: (context, value, child) => StreamProvider<List<UserTodo>>.value(
        value: context.read<FirebaseFirestoreService>().getAllDailyTodos(
          value.userLocal?.idbuz ?? '',
        ),
        initialData: const [],
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'Hello ${value.userLocal?.fullname}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                  child: Consumer<List<UserTodo>>(
                    builder: (context, todos, _) {
                      final finishedTask = todos
                          .where((todo) => todo.status == "completed")
                          .length;
                      return BannerDashboardWidget(
                        finishedTask: finishedTask,
                        allTask: todos.length,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 29),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Keuangan Minggu ini',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                _BannerCashflow(
                  userId: value.userLocal?.uid ?? "",
                  businessId: value.userLocal?.idbuz ?? "",
                ),

                const SizedBox(height: 29),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "TO DO",
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Consumer<List<UserTodo>>(
                        builder: (context, todos, _) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bgPink.colors,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              todos.length.toString(),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: 12,
                                    color: AppColors.textTaskRed.colors,
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Consumer<List<UserTodo>>(
                      builder: (context, todos, _) {
                        if (todos.isEmpty) {
                          return const _EmptyTaskWidget();
                        } else {
                          return _TaskListWidget(tasks: todos);
                        }
                      },
                    ),
                  ),
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
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/addTask',
                      arguments: sp.userLocal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerCashflow extends StatelessWidget {
  final String userId;
  final String businessId;
  const _BannerCashflow({required this.userId, required this.businessId});

  @override
  Widget build(BuildContext context) {
    final firestore = context.read<FirebaseFirestoreService>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<num>(
              stream: firestore.getTotalCashflowByType(
                userId,
                businessId,
                DateTime.now(),
                "weekly",
                "income",
              ),
              builder: (context, snapshot) {
                final income = snapshot.data ?? 0;
                return BannerCashflowWidget(
                  title: "Pemasukan",
                  money: income.toInt(),
                  color: AppColors.bgBlue.colors,
                  imgAssets: "assets/img/ic_in.png",
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<num>(
              stream: firestore.getTotalCashflowByType(
                userId,
                businessId,
                DateTime.now(),
                "weekly",
                "expense",
              ),
              builder: (context, snapshot) {
                final expense = snapshot.data ?? 0;
                return BannerCashflowWidget(
                  title: "Pengeluaran",
                  money: expense.toInt(),
                  color: AppColors.bgCream.colors,
                  imgAssets: "assets/img/ic_out.png",
                );
              },
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
        },
      ),
    );
  }
}

class _EmptyTaskWidget extends StatelessWidget {
  const _EmptyTaskWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/img/ic_empty.png",
          width: 81,
          height: 81,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 36),
        Text(
          "Data Task kamu kosong",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
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
