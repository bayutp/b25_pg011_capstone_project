import 'package:b25_pg011_capstone_project/static/helper.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BannerPlanWidget extends StatelessWidget {
  final int finishedTask;
  final int allTask;
  final String category;

  const BannerPlanWidget({
    super.key,
    required this.category,
    required this.finishedTask,
    required this.allTask,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
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
                  padding: const EdgeInsets.only(bottom: 52, left: 15, top: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Helper.progressText(finishedTask, allTask),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 8),
                      Text(
                        category,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Image.asset(
                    'assets/img/ic_onboarding.png',
                    height: 132,
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
