import 'package:b25_pg011_capstone_project/provider/main/bottomnav_provider.dart';
import 'package:b25_pg011_capstone_project/screen/cashflow/cashflow_screen.dart';
import 'package:b25_pg011_capstone_project/screen/home/home_screen.dart';
import 'package:b25_pg011_capstone_project/screen/plan/plan_screen.dart';
import 'package:b25_pg011_capstone_project/screen/profile/profile_screen.dart';
import 'package:b25_pg011_capstone_project/widget/bottomnav_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BottomnavProvider>(
        builder: (context, value, child) {
          return switch (value.getIndex) {
            0 => HomeScreen(),
            1 => PlanScreen(),
            2 => CashflowScreen(),
            _ => ProfileScreen(),
          };
        },
      ),
      bottomNavigationBar: Consumer<BottomnavProvider>(
        builder: (context, value, child) {
          return BottomnavWidget(
            currentIndex: value.getIndex,
            onTap: (index) {
              value.setIndex = index;
            },
          );
        },
      ),
    );
  }
}
