import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // Initialize Supabase with environment variables
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!, // Your Supabase project URL
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!, // Your Supabase anonymous key
    );
  }

  // Save activity data into the 'activities' table
  static Future<void> saveActivity({
    required String time,
    required double speed,
    required double distance,
    required String profileId,
  }) async {
    final response = await client.from('activities').insert({
      'time': time,
      'speed': speed,
      'distance': distance,
      'profile_id': profileId,
    });

    // Check for errors
    if (response.error != null) {
      print('Error inserting activity: ${response.error!.message}');
    } else {
      print('Activity saved successfully');
    }
  }
}
