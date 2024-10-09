import 'package:flutter/material.dart';
import 'package:wolkman/components/cards-activities.dart';

class ListActivities extends StatelessWidget {
  final String? userId;
  const ListActivities({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Liste des activitées")),
        body: CardsActivities(userId: userId));
  }
}
