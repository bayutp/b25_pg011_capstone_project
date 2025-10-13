import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _EmptyPlaningWidget(),
              const SizedBox(height: 39),
              _TotalTaskWidget(),
              const SizedBox(height: 28),
              _DatePickerWidget(),
              const SizedBox(height: 35),
              // _StatusTaskWidget(),
              // const SizedBox(height: 28),
              _EmptyTaskWidget(),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ButtonWidget(
                  key: const Key('tambah_data_button'),
                  title: "Tambah Data",
                  textColor: AppColors.btnTextWhite.colors,
                  foregroundColor: AppColors.bgSoftGreen.colors,
                  backgroundColor: AppColors.btnGreen.colors,
                  onPressed: () {
                    // Handle button press
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPlaningWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 33),
        decoration: BoxDecoration(
          color: AppColors.bgGrey.colors,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/ic_empty_white.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'Data Category kosong',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey.colors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalTaskWidget extends StatelessWidget {
  const _TotalTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "TO DO",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 16),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.bgPink.colors,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "0",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 12,
                color: AppColors.textTaskRed.colors,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePickerWidget extends StatelessWidget {
  const _DatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DatePickerWidget(
        onDateChange: (date) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected date: $date'),
              backgroundColor: AppColors.snackbarSuccess.colors,
            ),
          );
        },
      ),
    );
  }
}

class _EmptyTaskWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/img/ic_empty.png",
            width: 81,
            height: 81,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 36),
          Text(
            "Data Task kamu kosong",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            "Tambahkan Task kamu hari ini",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textGrey.colors,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
