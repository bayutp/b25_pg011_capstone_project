import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/style/typography/app_text_style.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final Function(DateTime) onDateChange;
  const DatePickerWidget({super.key, required this.onDateChange});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: DatePicker(
        DateTime.now(),
        selectionColor: AppColors.bgSoftGreen.colors,
        selectedTextColor: AppColors.bgGreen.colors,
        locale: "id-ID",
        deactivatedColor: AppColors.textGrey.colors, // tanggal yang tidak aktif
        daysCount: 30,
        dayTextStyle: AppTextStyle.dayTextStyle(context),
        monthTextStyle: AppTextStyle.monthTextStyle(context),
        dateTextStyle: AppTextStyle.dateTextStyle(context),
        onDateChange: (date) {
          onDateChange(date);
        },
      ),
    );
  }
}
