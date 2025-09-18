import 'package:b25_pg011_capstone_project/static/helper.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BannerCashflowWidget extends StatelessWidget {
  final String title;
  final int money;
  final Color color;
  final String imgAssets;

  const BannerCashflowWidget({
    super.key,
    required this.title,
    required this.money,
    required this.color,
    required this.imgAssets,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        elevation: 0,
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imgAssets, width: 35, height: 35),
                SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textGrey.colors,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  Helper.formatCurrency(money),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    color: AppColors.textTaskBlack.colors,
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
