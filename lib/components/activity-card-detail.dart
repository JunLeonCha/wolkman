import 'package:flutter/material.dart';
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
          return const Center(child: CircularProgressIndicator()); //Loader
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        }

        final activity = snapshot.data; // data snapshot

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
