import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FollowUpSheet extends StatelessWidget {
  const FollowUpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            ElevatedButton(onPressed: () => {}, child: Text("Moi")),
            const Gap(20),
            ElevatedButton(onPressed: () => {}, child: Text("Suivi")),
            const Gap(20),
            ElevatedButton(
                onPressed: () => {Get.toNamed("/map")}, child: Text("Map")),
          ],
        ),
      ],
    );
  }
}
