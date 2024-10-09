import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityServices extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

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
}
