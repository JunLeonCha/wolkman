import 'package:flutter/material.dart';
import 'package:wolkman/components/activity-card-detail.dart';

class CourseDetail extends StatelessWidget {
  const CourseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Accueil"))),
      body: const ActivityCardDetail(),
    );
  }
}
