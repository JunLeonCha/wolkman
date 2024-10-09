import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wolkman/services/course/activity.dart';
import 'package:wolkman/views/activity-detail.dart';

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
          return const Center(child: Text('Aucune activité trouvée.'));
        }

        // Affichage de toutes les activités dans une ListView
        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            final String formattedDate = DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(activity?['created_at']));
            return GestureDetector(
              onTap: () =>
                  {Get.to(ActivityDetails(activityId: activity?["id"]))},
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Colors.cyan[50],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(16),
                      Text(
                        'Nom de l\'activité: ${activity['name'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('Fais le: ${formattedDate ?? 'N/A'}'),
                      Text(
                          'Temps de l\'activité: ${activity['time'] ?? 'N/A'} minutes'),
                      Text(
                          'Vitesse moyenne: ${activity['speed'] ?? 'N/A'} km/h'),
                      Text(
                          'Distance parcouru: ${activity['distance'] ?? 'N/A'} km'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
