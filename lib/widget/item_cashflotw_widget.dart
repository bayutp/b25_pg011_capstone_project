import 'package:b25_pg011_capstone_project/static/helper.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';

class ItemCashflotwWidget extends StatelessWidget {
  final String title;
  final int money;
  final Function() onTap;

  const ItemCashflotwWidget({
    super.key,
    required this.money,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          elevation: 0,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: AppColors.bgGreen.colors,
                      ),
                      SizedBox(width: 6),
                      Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 13),
                  Text(
                    Helper.formatCurrency(money),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
