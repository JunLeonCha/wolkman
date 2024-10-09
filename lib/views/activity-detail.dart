import 'package:flutter/material.dart';
import 'package:wolkman/components/activity-card-detail.dart';

class ActivityDetails extends StatelessWidget {
  final num activityId; // Ajoutez ce champ pour recevoir l'ID

  const ActivityDetails(
      {super.key, required this.activityId}); // Modifiez le constructeur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Détails de l'activité"))),
      body: ActivityCardDetail(activityId: activityId), // Passez l'ID ici
    );
  }
}
