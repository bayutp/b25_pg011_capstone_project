import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../style/colors/app_colors.dart';
import '../../widget/banner_cashflow_widget.dart';
import '../../widget/card_home.dart';
import '../../widget/list_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int completed =2;
    final int total = 5;
    final todos = [
      {'department': 'Marketing', 'task': 'Making 3 Post For Social Media', 'isDone': false},
      {'department': 'Production', 'task': 'Evaluasi Produk', 'isDone': false},
      {'department': 'Finance', 'task': 'Update Monthly Report', 'isDone': true},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Hello JohnDoe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.notifications, size: 28),
                onPressed: ()  {

                },
              ),
            ],
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskCard(
              completedTasks: completed,
              totalTasks: total,
              imagePath: 'assets/img/ic_onboarding.png',
        ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Keuangan Minggu ini',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: _BannerCashflow(),
            ),
            const SizedBox(height: 29),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: ToDoList(todos: todos),
            ),
          ],
        ),
      ),

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