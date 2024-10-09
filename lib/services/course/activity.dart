import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityServices extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  // Observable pour stocker les détails de l'activité
  var activityDetail = {}.obs;

  Future<List<Map<String, dynamic>>> fetchCurrentUserActivityDetails(
      String id) async {
    try {
      final List<dynamic> activities =
          await supabase.from("activities").select("*").eq("profile_id", id);
      print(activities);
      // Convertir les résultats en List<Map<String, dynamic>>
      return activities
          .map((activity) => activity as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching activity details: $e');
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  Future<void> getCurrentUserActivityDetails(String id) async {}

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
      print('Error fetching last activity details: $e');
      return null;
    }
  }
}
