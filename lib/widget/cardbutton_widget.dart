import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CardButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CardButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.btnWhite.colors),
          side: WidgetStateProperty.all(
            BorderSide(color: Colors.grey.shade200),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),

          overlayColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.grey.shade200;
            }
            return null;
          }),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
