import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wolkman/services/user/user-services.dart';
import 'package:wolkman/services/course/activity.dart';

class LastActivities extends StatelessWidget {
  LastActivities({super.key});

  final UserServices _userServices = UserServices();
  final ActivityServices _activityServices = ActivityServices();
  final Widget paysageSVG = SvgPicture.asset('assets/paysage_icon.svg');
  final Widget obstacleSVG = SvgPicture.asset('assets/obstacle.svg');
  final Widget likeSvg = SvgPicture.asset('assets/like.svg');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userServices
          .getUserDetails(), // Récupérer les détails de l'utilisateur
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (userSnapshot.hasError) {
          return Center(child: Text('Erreur : ${userSnapshot.error}'));
        }

        final user = userSnapshot.data;
        final String displayName = user?["display_name"] ?? 'Nom indisponible';

        return FutureBuilder(
          future:
              _activityServices.getCurrentUserLastActivityDetails(user?["id"]),
          builder: (context, activitySnapshot) {
            if (activitySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (activitySnapshot.hasError) {
              return Center(child: Text('Erreur : ${activitySnapshot.error}'));
            }

            final activity = activitySnapshot.data;
            final String distance = '${activity["distance"].toString()} Km';
            final String speed = '${activity["speed"].toString()} Km/h';
            final String time = '${activity?["time"]}';
            final String formattedDate = DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(activity?['created_at']));

            return Container(
              child: Column(
                children: [
                  const Row(
                    children: const [
                      Text("Ma dernière activité"),
                    ],
                  ),
                  Card(
                    color: Colors.cyan[50],
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(children: [
                            paysageSVG,
                            const Gap(16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(displayName),
                                Text(formattedDate),
                              ],
                            ),
                          ]),
                          const Gap(32),
                          Row(
                            children: [
                              obstacleSVG,
                              const Gap(16),
                              const Text("Saut d'obstacles"),
                            ],
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    _buildActivityDetail(distance, "Distance"),
                                    const Gap(16),
                                    _buildActivityDetail(speed, "Vitesse"),
                                    const Gap(16),
                                    _buildActivityDetail(time, "Durée"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Divider(
                            height: 20,
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                            color: Colors.cyan[300],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              likeSvg,
                              const Gap(8),
                              const Text("3 personnes ont aimés ceci"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActivityDetail(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20.0)),
        const Gap(4),
        Text(label),
      ],
    );
  }
}
