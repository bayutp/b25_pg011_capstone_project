import 'package:b25_pg011_capstone_project/widget/item_cashflotw_widget.dart';
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
  List<Map<String, dynamic>> plans = [
    {
      "category": "Marketing",
      "task": "Making 3 Post For Social Media",
      "done": false,
    },
    {"category": "Production", "task": "Evaluasi Produk", "done": false},
    {"category": "Finance", "task": "Evaluasi Produk", "done": false},
    {"category": "Inventory", "task": "Evaluasi Produk", "done": false},
  ];

  List<Map<String, dynamic>> cashflows = [
    {"title": "Pengeluaran", "money": 10000},
    {"title": "Pemasukan", "money": 10000},
    {"title": "Pengeluaran", "money": 10000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // child: BannerPlanWidget(
        //   category: "Marketing",
        //   finishedTask: 12,
        //   allTask: 28,
        // ),
        child: ListView.builder(
          itemCount: cashflows.length,
          itemBuilder: (context, index) {
            final cashflow = cashflows[index];
            return ItemCashflotwWidget(
              money: cashflow["money"],
              title: cashflow["title"],
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(cashflow["title"])));
              },
            );
          },
        ),
        // SizedBox(
        //   height: 156,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     shrinkWrap: true,
        //     itemCount: plans.length,
        //     itemBuilder: (context, index) {
        //       final plan = plans[index];
        //       return BannerPlanWidget(
        //         category: plan["category"],
        //         finishedTask: 0,
        //         allTask: 0,
        //         onTap: () {
        //           ScaffoldMessenger.of(
        //             context,
        //           ).showSnackBar(SnackBar(content: Text(plan["category"])));
        //         },
        //       );
        //     },
        //   ),
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
