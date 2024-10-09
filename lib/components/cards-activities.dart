import 'package:flutter/material.dart';
import 'package:wolkman/services/course/activity.dart';

class CardsActivities extends StatelessWidget {
  final String? userId;

  const CardsActivities({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final ActivityServices activityServices = ActivityServices();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: activityServices.fetchCurrentUserActivitiesDetails(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        }

        final activities = snapshot.data;

        if (activities == null || activities.isEmpty) {
          return Center(child: Text('Aucune activité trouvée.'));
        }

        // Affichage de toutes les activités dans une ListView
        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity ID: ${activity['id'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Name: ${activity['name'] ?? 'N/A'}'),
                    Text('Created At: ${activity['created_at'] ?? 'N/A'}'),
                    Text('Time: ${activity['time'] ?? 'N/A'} minutes'),
                    Text('Speed: ${activity['speed'] ?? 'N/A'} km/h'),
                    Text('Distance: ${activity['distance'] ?? 'N/A'} km'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
