import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wolkman/views/list-activities.dart';

class FollowUpSheet extends StatelessWidget {
  final String? userId;

  const FollowUpSheet({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            ElevatedButton(onPressed: () => {}, child: const Text("Moi")),
            const Gap(20),
            ElevatedButton(onPressed: () => {}, child: const Text("Suivi")),
            const Gap(20),
            ElevatedButton(
                onPressed: () => {Get.to(ListActivities(userId: userId))},
                child: const Text("Liste des activitées")),
            const Gap(20),
            ElevatedButton(
                onPressed: () => {Get.toNamed("/map")},
                child: const Text("Map")),
          ],
        ),
      ],
    );
  }
}
