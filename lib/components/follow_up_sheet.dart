import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wolkman/views/list-activities.dart';

class FollowUpSheet extends StatelessWidget {
  final String? userId;
  final ScrollController _scrollController = ScrollController();

  FollowUpSheet({super.key, required this.userId});

  void scrollLeft() {
    _scrollController.animateTo(
      _scrollController.position.pixels - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    _scrollController.animateTo(
      _scrollController.position.pixels + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left),
            color: Colors.cyan[300],
            onPressed: scrollLeft,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(onPressed: () => {}, child: const Text("Moi")),
                  const Gap(20),
                  ElevatedButton(
                      onPressed: () => {}, child: const Text("Suivi")),
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
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            color: Colors.cyan[300],
            onPressed: scrollRight,
          ),
        ],
      ),
    );
  }
}
