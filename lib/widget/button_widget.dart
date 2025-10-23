import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final bool isLoading;

  const ButtonWidget({
    super.key,
    required this.title,
    required this.textColor,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(foregroundColor),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // custom radius
            ),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
