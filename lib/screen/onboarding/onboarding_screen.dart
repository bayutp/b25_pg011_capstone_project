import 'package:b25_pg011_capstone_project/widget/banner_plan_widget.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  // final _formKey = GlobalKey<FormState>();
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // List<Map<String, dynamic>> plans = [
  //   {
  //     "category": "Marketing",
  //     "task": "Making 3 Post For Social Media",
  //     "done": false,
  //   },
  //   {"category": "Production", "task": "Evaluasi Produk", "done": false},
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BannerPlanWidget(
          category: "Marketing",
          finishedTask: 12,
          allTask: 28,
        ),
        // ListView.builder(
        //   itemCount: plans.length,
        //   itemBuilder: (context, index) {
        //     final plan = plans[index];
        //     return ItemPlanWidget(
        //       category: plan["category"],
        //       task: plan["task"],
        //       isChecked: plan["done"],
        //       onChange: (value) {
        //         setState(() {
        //           plans[index]["done"] = value ?? false;
        //         });
        //       },
        //     );
        //   },
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Expanded(
        //       child: BannerCashflowWidget(
        //         title: "Pemasukan",
        //         money: 0,
        //         color: AppColors.bgBlue.colors,
        //         imgAssets: "assets/img/ic_in.png",
        //       ),
        //     ),
        //     Expanded(
        //       child: BannerCashflowWidget(
        //         title: "Pengeluaran",
        //         money: 0,
        //         color: AppColors.bgCream.colors,
        //         imgAssets: "assets/img/ic_out.png",
        //       ),
        //     ),
        //   ],
        // ),
      ),
      // child: ButtonWidget(
      //   title: "Mulai Sekarang",
      //   textColor: AppColors.bgGreen.colors,
      //   foregroundColor: AppColors.btnGreen.colors,
      //   backgroundColor: AppColors.btnWhite.colors,
      //   onPressed: () async {
      //     await context.read<UserLocalProvider>().setStatusUser(
      //       UserLocal(statusLogin: true),
      //     );
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(context.read<UserLocalProvider>().message),
      //       ),
      //     );
      //   },
      // ),
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
    );
  }
}
