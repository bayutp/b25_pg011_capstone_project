import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/style/typography/app_text_style.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateChange;
  const DatePickerWidget({super.key, required this.onDateChange});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final DatePickerController _controller = DatePickerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.setDateAndAnimate(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: DatePicker(
        controller: _controller,
        DateTime.now().subtract(const Duration(days: 30)),
        initialSelectedDate: DateTime.now(),
        selectionColor: AppColors.bgSoftGreen.colors,
        selectedTextColor: AppColors.bgGreen.colors,
        locale: "id-ID",
        deactivatedColor: AppColors.textGrey.colors, // tanggal yang tidak aktif
        daysCount: 60,
        dayTextStyle: AppTextStyle.dayTextStyle(context),
        monthTextStyle: AppTextStyle.monthTextStyle(context),
        dateTextStyle: AppTextStyle.dateTextStyle(context),
        onDateChange: (date) {
          widget.onDateChange(date);
        },
      ),
    );
  }
}
