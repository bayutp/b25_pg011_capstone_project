import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  // final _formKey = GlobalKey<FormState>();
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ButtonWidget(
            title: "Mulai Sekarang",
            textColor: AppColors.bgGreen.colors,
            foregroundColor: AppColors.btnGreen.colors,
            backgroundColor: AppColors.btnWhite.colors,
            onPressed: () async {
              await context.read<UserLocalProvider>().setStatusUser(
                UserLocal(statusLogin: true),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.read<UserLocalProvider>().message),
                ),
              );
            },
          ),
          // child: Form(
          //   key: _formKey,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       TextFormFieldWidget(
          //         controller: _emailController,
          //         label: "Email",
          //         obscureText: false,
          //         validator: (value) {
          //           if (value == null || value.isEmpty) {
          //             return "Email tidak boleh kosong";
          //           }
          //           if (!value.contains("@")) {
          //             return "Format email tidak valid";
          //           }
          //           return null;
          //         },
          //       ),
          //       const SizedBox(height: 16),
          //       TextFormFieldWidget(
          //         controller: _passwordController,
          //         label: "Password",
          //         obscureText: true,
          //         validator: (value) {
          //           if (value == null || value.isEmpty) {
          //             return "Password tidak boleh kosong";
          //           }
          //           if (value.length < 6) {
          //             return "Password minimal 6 karakter";
          //           }
          //           return null;
          //         },
          //       ),
          //       const SizedBox(height: 24),
          //       ButtonWidget(
          //         title: "Login",
          //         textColor: AppColors.btnTextWhite.colors,
          //         foregroundColor: AppColors.btnWhite.colors,
          //         backgroundColor: AppColors.btnGreen.colors,
          //         onPressed: () {
          //           if (_formKey.currentState!.validate()) {
          //             debugPrint(
          //               "Login valid, email: ${_emailController.text}",
          //             );
          //           }
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
