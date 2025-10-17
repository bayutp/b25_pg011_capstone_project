import 'package:b25_pg011_capstone_project/screen/main/main_screen.dart';
import 'package:b25_pg011_capstone_project/screen/profile/edit_profile_screen.dart';
import 'package:b25_pg011_capstone_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilCheckScreen extends StatelessWidget {
  const ProfilCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.read<AuthService>();
    return FutureBuilder(
      future: service.getUserBusiness(),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshots.data == null || snapshots.data!.isEmpty) {
          return EditProfileScreen();
        } else {
          return MainScreen();
        }
      },
    );
  }
}
