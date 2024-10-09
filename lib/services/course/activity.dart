import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/user/user-services.dart'; // Import the UserServices class

class ActivityServices extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final UserServices userServices =
      UserServices(); // Create an instance of UserServices

  var activityDetail = {}.obs;

  Future<Map<String, dynamic>> getActivityDetails(num activityId) async {
    try {
      final activity = await supabase
          .from("activities")
          .select("*")
          .eq("id", activityId)
          .single();
      return activity;
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserActivitiesDetails(
      String? id) async {
    try {
      final List<dynamic> activities = await supabase
          .from("activities")
          .select("*")
          .eq("profile_id", id as String);
      print(activities);
      return activities
          .map((activity) => activity as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching activity details: $e');
      return [];
    }
  }

  // Get the current user's last activity details
  Future<dynamic> getCurrentUserLastActivityDetails(String id) async {
    try {
      final lastActivity = await supabase
          .from("activities")
          .select("*")
          .eq("profile_id", id)
          .order("created_at", ascending: false)
          .limit(1)
          .single();
      return lastActivity;
    } catch (e) {
      print('Erreur: $e');
      return null;
    }
  }

  // Insert a new activity into the database
  Future<dynamic> insertActivity({
    required String time,
    required double speed,
    required double distance,
    required String profileId,
  }) async {
    try {
      // Get the current user's UUID using UserServices
      final user = userServices.getCurrentUser();

      // Check if the user is logged in
      if (user == null) {
        print('No user is logged in.');
        return null; // Return null if no user is found
      }

      String profileId = user.id; // Use the UUID from the authenticated user

      // Insert the new activity
      final response = await supabase.from("activities").insert({
        'time': time,
        'speed': speed,
        'distance': distance,
        'profile_id': profileId,
      });

      // Check for errors
      if (response.error != null) {
        print('Error inserting activity: ${response.error!.message}');
        return null; // Return null in case of error
      } else {
        print(
            'Activity inserted successfully: ${response.data}'); // Log the response data
        return response.data; // Return the full response
      }
    } catch (e) {
      print('Error during insertion: $e');
      return null; // Return null in case of exception
    }
  }
}
