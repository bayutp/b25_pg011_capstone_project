import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGreen.colors,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/img/ic_onboarding.png", height: 288),
                  SizedBox.square(dimension: 50),
                  Text(
                    "Cerdas Catat, Cerdas Rencana",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox.square(dimension: 20),
                  Text(
                    "Catat penjualan dan atur keuangan usaha agar berkembang lebih berkelanjutan.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox.square(dimension: 60),
                  ButtonWidget(
                    title: "Mulai Sekarang",
                    textColor: AppColors.bgGreen.colors,
                    foregroundColor: AppColors.btnGreen.colors,
                    backgroundColor: AppColors.btnWhite.colors,
                    onPressed: () {
                      //todo: perlu ada pengecekan firts launch jika memang diperlukan muncul sekali saja
                      Navigator.pushReplacementNamed(
                        context,
                        NavigationRoute.loginRoute.name,
                      );
                    },
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
