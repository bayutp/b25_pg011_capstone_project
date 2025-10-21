import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'button_widget.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final String cancelButtonText;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmButtonText,
    required this.onConfirm,
    this.cancelButtonText = "Batal",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                InkWell(
                  child: Icon(
                    Icons.cancel_outlined,
                    color: AppColors.textGrey.colors,
                    size: 27,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ButtonWidget(
              title: confirmButtonText,
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              backgroundColor: const Color(0xFF546E41),
              foregroundColor: Colors.white.withAlpha((0.8 * 255).toInt()),
              textColor: Colors.white,
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  cancelButtonText,
                  style: TextStyle(
                    color: AppColors.textGreen.colors,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showAppConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmButtonText,
  required VoidCallback onConfirm,
  String cancelButtonText = "Batal",
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        content: content,
        confirmButtonText: confirmButtonText,
        onConfirm: onConfirm,
        cancelButtonText: cancelButtonText,
      );
    },
  );
}
