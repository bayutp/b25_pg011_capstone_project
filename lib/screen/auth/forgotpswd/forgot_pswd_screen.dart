import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/snackbar_widget.dart';
import 'package:b25_pg011_capstone_project/widget/textformfield_widget.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _keyForm = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Form(
        key: _keyForm,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset Password',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormFieldWidget(
                controller: _emailController,
                label: "Your Email",
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  } else if (!value.contains('@')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
                onChange: (value) {
                  if (_keyForm.currentState != null) {
                     _keyForm.currentState!.validate();
                  }
                },
              ),
              const SizedBox(height: 20),
              ButtonWidget(
                title: "Kirim",
                textColor: AppColors.btnTextWhite.colors,
                foregroundColor: AppColors.bgSoftGreen.colors,
                backgroundColor: AppColors.bgGreen.colors,
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackbarWidget(message: "Data dikirim", success: true),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
