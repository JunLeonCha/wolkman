import 'package:flutter/material.dart';
import 'package:wolkman/views/Homepage.dart';
import 'package:wolkman/views/maps.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/second': (context) => const Homepage(),
        '/': (context) => Maps(),
      },
    ),
  );
}
