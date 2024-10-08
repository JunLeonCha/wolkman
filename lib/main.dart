import 'package:flutter/material.dart';
import 'package:wolkman/services/supabase.dart';
import 'package:wolkman/views/Homepage.dart';
import 'package:wolkman/views/maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wolkman/views/authentication.dart';
import 'package:get/get.dart'; // Import de GetX

void main() {
  runApp(
    GetMaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      getPages: [
        GetPage(name: '/sign_in', page: () => Homepage()),
        GetPage(name: '/', page: () => Authentication()),
      ],
      // routes: {
      //   // When navigating to the "/" route, build the FirstScreen widget.
      //   '/sign_in': (context) => const Homepage(),
      //   '/': (context) => Authentication(),
      //   // When navigating to the "/second" route, build the SecondScreen widget.
      //   '/second': (context) => const Maps(),
      // },
    ),
  );
}
