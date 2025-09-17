import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGreen.colors,
      body: Center(
        child: Text(
          "Onboarding Page",
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(color: AppColors.textWhite.colors),
        ),
      ),
    );
  }
}
