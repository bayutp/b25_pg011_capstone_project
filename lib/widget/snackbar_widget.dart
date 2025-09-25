import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';

class SnackbarWidget extends SnackBar {
  SnackbarWidget({
    super.key,
    required String message,
    required bool success,
    IconData icon = Icons.check_circle_rounded,
  }) : super(
         content: Row(
           children: [
             Icon(
               icon,
               color: success
                   ? AppColors.snackbarSuccess.colors
                   : AppColors.snackbarFailed.colors,
             ),
             SizedBox(width: 8),
             Expanded(
               child: Text(
                 message,
                 style: TextStyle(
                   fontFamily: "Inter",
                   fontWeight: FontWeight.w400,
                   color: success
                       ? AppColors.snackbarSuccess.colors
                       : AppColors.snackbarFailed.colors,
                 ),
               ),
             ),
           ],
         ),
         duration: Duration(seconds: 3),
       );
}
