import 'package:flutter/material.dart';
import 'package:wolkman/services/supabase.dart';
import 'package:wolkman/services/user/user-services.dart';
import 'package:wolkman/views/Homepage.dart';
import 'package:wolkman/views/maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wolkman/views/authentication.dart';
import 'package:get/get.dart'; // Import de GetX

void main() async {
  await dotenv.load(fileName: ".env");
  await SupabaseService.initialize();

  final currentUser = UserServices().getCurrentUser();

  runApp(
    GetMaterialApp(
      title: 'Named Routes Demo',
      initialRoute: currentUser == null ? '/sign_in' : '/',
      getPages: [
        GetPage(name: '/', page: () => Homepage()),
        GetPage(name: '/sign_in', page: () => Authentication()),
        GetPage(name: '/map', page: () => Maps()),
      ],
    ),
  );
}
