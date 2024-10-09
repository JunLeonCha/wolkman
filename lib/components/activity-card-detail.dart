import 'package:flutter/material.dart';
import 'package:wolkman/services/course/activity.dart';
import 'package:wolkman/services/user/user-services.dart';

class ActivityCardDetail extends StatefulWidget {
  const ActivityCardDetail({super.key});

  @override
  State<ActivityCardDetail> createState() => _ActivityCardDetailState();
}

class _ActivityCardDetailState extends State<ActivityCardDetail> {
  final currentUser = UserServices().getCurrentUser()?.id;

  @override
  Widget build(BuildContext context) {
    // Récupérer les détails de l'activité pour l'utilisateur actuel
    final activityDetail = ActivityServices()
        .getCurrentUserActivityDetails(currentUser.toString());

    return Expanded(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Si les détails sont chargés, les afficher
            activityDetail != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activity ID: ${activityDetail['id'] ?? 'N/A'}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                            'Created At: ${activityDetail['created_at'] ?? 'N/A'}'),
                        Text(
                            'Time: ${activityDetail['time'] ?? 'N/A'} minutes'),
                        Text('Speed: ${activityDetail['speed'] ?? 'N/A'} km/h'),
                        Text(
                            'Distance: ${activityDetail['distance'] ?? 'N/A'} km'),
                        Text(
                            'Profile ID: ${activityDetail['profile_id'] ?? 'N/A'}'),
                      ],
                    ),
                  )
                : const Text('No activity details available.'),
          ],
        ),
      ),
    );
  }
}
