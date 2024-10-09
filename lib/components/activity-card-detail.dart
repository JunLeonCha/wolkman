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
          return const Center(child: CircularProgressIndicator()); // Loader
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        }

        final activity = snapshot.data; // Data snapshot

        if (activity == null) {
          return Center(child: Text('Aucune activité trouvée.'));
        }

        return Container(
          margin: const EdgeInsets.symmetric(
              vertical: 20.0, horizontal: 10.0), // Margin for spacing
          child: Card(
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
                    'Activity ID: ${activity['id'] ?? 'N/A'}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueAccent),
                  ),
                  SizedBox(height: 10),
                  Divider(
                      thickness: 1.5,
                      color: Colors.grey[400]), // Separator line
                  SizedBox(height: 10),
                  Text(
                    'Created At: ${activity['created_at'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Time: ${activity['time'] ?? 'N/A'} minutes',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Speed: ${activity['speed'] ?? 'N/A'} km/h',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Distance: ${activity['distance'] ?? 'N/A'} km',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Profile ID: ${activity['profile_id'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
