import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wolkman/models/user_models.dart';
import 'package:wolkman/services/user/user-services.dart';

class LastActivities extends StatelessWidget {
  LastActivities({super.key});

  final user = UserServices().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: const [
              Text("Ma dernière activité"),
            ],
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(children: [
                        Text("ajouter une image"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.userMetadata?["display_name"],
                              textAlign: TextAlign.left,
                            ),
                            Text("25 mars 2025")
                          ],
                        ),
                      ])
                    ],
                  ),
                  Gap(16),
                  Row(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text("kgjdlkgjkl"),
                                  Gap(4),
                                  Text("2235I3O3I5O3")
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text("kgjdlkgjkl"),
                                  Gap(4),
                                  Text("2235I3O3I5O3")
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text("kgjdlkgjkl"),
                                  Gap(4),
                                  Text("2235I3O3I5O3")
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [Text("Ajouter un truc")],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
