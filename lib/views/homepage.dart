import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wolkman/components/follow_up_sheet.dart';
import 'package:wolkman/components/last_activities.dart';
import 'package:wolkman/services/auth-services.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Accueil"))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                FollowUpSheet(
                    userId: _authService.supabase.auth.currentUser?.id),
                const Gap(16),
                LastActivities(),
                ElevatedButton(
                  onPressed: () => {_authService.signOut()},
                  child: Text("Déconnexion"),
                ),
                const Gap(20),
                IconButton(
                    onPressed: () => {Get.toNamed('/map')},
                    icon: Image.asset('assets/map.png'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
