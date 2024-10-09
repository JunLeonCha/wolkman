import 'package:flutter/material.dart';
import 'package:wolkman/services/course/activity.dart';

class ActivityCardDetail extends StatelessWidget {
  final num activityId; // Recevez l'ID de l'activité

  const ActivityCardDetail({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final ActivityServices activityServices =
        ActivityServices(); // Instancier le service

    return FutureBuilder<Map<String, dynamic>>(
      future: activityServices.getActivityDetails(
          activityId), // Récupérer les détails de l'activité
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Loader pendant le chargement
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Erreur : ${snapshot.error}')); // Gérer l'erreur
        }

        final activity = snapshot.data; // Données de l'activité

        // Vérifier si l'activité est nulle
        if (activity == null) {
          return Center(child: Text('Aucune activité trouvée.'));
        }

        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity ID: ${activity['id'] ?? 'N/A'}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text('Created At: ${activity['created_at'] ?? 'N/A'}'),
                    Text('Time: ${activity['time'] ?? 'N/A'} minutes'),
                    Text('Speed: ${activity['speed'] ?? 'N/A'} km/h'),
                    Text('Distance: ${activity['distance'] ?? 'N/A'} km'),
                    Text('Profile ID: ${activity['profile_id'] ?? 'N/A'}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
