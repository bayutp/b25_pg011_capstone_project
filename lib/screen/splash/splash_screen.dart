import 'dart:async';

import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/static/navigation_route.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    final provider = context.read<UserLocalProvider>();
    provider.getStatusUser();
    final user = provider.userLocal;
    final isFirstLaunch = user?.statusFirstLaunch ?? true;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Setelah 3 detik pindah ke halaman utama
    Future.delayed(Duration(seconds: 3), () {
      if (isFirstLaunch) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            NavigationRoute.onboardingRoute.name,
            (route) => false,
          );
        }
        return;
      }
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          NavigationRoute.userCheck.name,
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite.colors,
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: Image.asset(
            'assets/icon/app_logo.png',
            fit: BoxFit.contain,
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }
}
