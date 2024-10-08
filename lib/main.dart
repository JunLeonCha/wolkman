import 'package:flutter/material.dart';
import 'package:wolkman/dbcontext/supabase.dart';
import 'package:wolkman/views/Homepage.dart';
import 'package:wolkman/views/maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wolkman/views/authentication.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  print(dotenv.env["SUPABASE_URL"]);
  await SupabaseService.initialize();

  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/sign_in': (context) => const Homepage(),
        '/': (context) => Authentication(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => const Maps(),
      },
    ),
  );
}
