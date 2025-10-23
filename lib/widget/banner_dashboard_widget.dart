import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BannerDashboardWidget extends StatelessWidget {
  final int finishedTask;
  final int allTask;
  const BannerDashboardWidget({
    super.key,
    required this.finishedTask,
    required this.allTask,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: AppColors.bgGreen.colors,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
        ),
        elevation: 0,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 41, left: 29, top: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hari ini",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textWhite.colors,
                        ),
                      ),
                      SizedBox(height: 13),
                      Text(
                        "$finishedTask/$allTask Tasks",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                          color: AppColors.textWhite.colors,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Image.asset('assets/img/ic_task.png', height: 158),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
