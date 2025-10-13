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
    return Consumer<BottomnavProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
          body: switch (navProvider.getIndex) {
            0 => const HomeScreen(),
            1 => const PlanScreen(),
            2 => const CashflowScreen(),
            _ => const ProfileScreen(),
          },
          bottomNavigationBar: BottomnavWidget(
            currentIndex: navProvider.getIndex,
            onTap: (index) {
              navProvider.setIndex = index;
            },
          ),
        );
      },
    );
  }
}