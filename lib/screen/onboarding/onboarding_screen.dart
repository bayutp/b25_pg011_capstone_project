import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGreen.colors,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ButtonWidget(
            title: "Mulai Sekarang",
            textColor: AppColors.bgGreen.colors,
            foregroundColor: AppColors.btnGreen.colors,
            backgroundColor: AppColors.btnWhite.colors,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
