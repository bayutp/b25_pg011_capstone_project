import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EmptyPlaningWidget(),
              const SizedBox(height: 39),
              // _TotalTaskWidget(),
              // const SizedBox(height: 28),
              // _DatePickerWidget(),
              // const SizedBox(height: 35),
              // _StatusTaskWidget(),
              // const SizedBox(height: 28),
              // _EmptyTaskWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPlaningWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
