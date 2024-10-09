import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wolkman/services/course/activity.dart';

class ActivityCardDetail extends StatelessWidget {
  final num activityId;

  const ActivityCardDetail({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final ActivityServices activityServices = ActivityServices();

    return FutureBuilder<Map<String, dynamic>>(
      future: activityServices.getActivityDetails(activityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loader
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        }

        final activity = snapshot.data; // Data snapshot

        if (activity == null) {
          return const Center(child: Text('Aucune activité trouvée.'));
        }

        return Container(
          margin: const EdgeInsets.symmetric(
              vertical: 20.0, horizontal: 10.0), // Margin for spacing
          child: Card(
            color: Colors.cyan[50],
            elevation: 4, // Shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding inside the card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nom de l\'activité: ${activity['name'] ?? 'N/A'}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueAccent),
                  ),
                  const Gap(10),
                  Divider(
                      thickness: 1.5,
                      color: Colors.grey[400]), // Separator line
                  const Gap(10),
                  Text(
                    'Fais le: ${activity['created_at'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 14),
                  ),
                  const Gap(5),
                  Text(
                    'Temps de l\'activité: ${activity['time'] ?? 'N/A'} minutes',
                    style: TextStyle(fontSize: 14),
                  ),
                  const Gap(5),
                  Text(
                    'Vitesse moyenne: ${activity['speed'] ?? 'N/A'} km/h',
                    style: TextStyle(fontSize: 14),
                  ),
                  const Gap(5),
                  Text(
                    'Distance parcouru:: ${activity['distance'] ?? 'N/A'} km',
                    style: TextStyle(fontSize: 14),
                  ),
                  const Gap(5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
