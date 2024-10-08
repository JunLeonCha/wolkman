import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wolkman/models/user_models.dart';
import 'package:wolkman/services/user/user-services.dart';

class LastActivities extends StatelessWidget {
  LastActivities({super.key});

  final user = UserServices().getCurrentUser();
  final Widget paysageSVG = SvgPicture.asset('assets/paysage_icon.svg');
  final Widget obstacleSVG = SvgPicture.asset('assets/obstacle.svg');
  final Widget likeSvg = SvgPicture.asset('assets/like.svg');

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return Container(
      child: Column(
        children: [
          Row(
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
                  Column(
                    children: [
                      Row(children: [
                        paysageSVG,
                        const Gap(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.userMetadata?["display_name"],
                              textAlign: TextAlign.left,
                            ),
                            Text(formattedDate.toString())
                          ],
                        ),
                      ])
                    ],
                  ),
                  const Gap(32),
                  Row(
                    children: [
                      obstacleSVG,
                      const Gap(16),
                      Text("Saut d'obstacles")
                    ],
                  ),
                  const Gap(16),
                  const Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "4.5km",
                                      style: TextStyle(
                                        fontSize: 24.0,
                                      ),
                                    ),
                                    Gap(4),
                                    Text("Distance")
                                  ],
                                )
                              ],
                            ),
                            const Gap(16),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "4.2km/h",
                                      style: TextStyle(
                                        fontSize: 24.0,
                                      ),
                                    ),
                                    Gap(4),
                                    Text("Vitesse")
                                  ],
                                )
                              ],
                            ),
                            const Gap(16),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "50'20",
                                      style: TextStyle(
                                        fontSize: 24.0,
                                      ),
                                    ),
                                    Gap(4),
                                    Text("Durée")
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Row(
                        children: [Text("Ajouter un truc")],
                      ))
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
                      const Text("3 personnes ont aimés ceci")
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
