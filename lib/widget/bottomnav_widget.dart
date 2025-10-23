import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BottomnavWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomnavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.bgSoftGreen.colors,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.outlineVariant,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
          tooltip: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sticky_note_2),
          label: "Planning",
          tooltip: "Planning",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time_filled),
          label: "Cashflow",
          tooltip: "Cashflow",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profil",
          tooltip: "Profil",
        ),
      ],
    );
  }
}
