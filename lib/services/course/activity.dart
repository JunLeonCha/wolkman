import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityServices {
  final SupabaseClient supabase = Supabase.instance.client;

  getCurrentUserActivityDetails(String id) async {
    final activity = await supabase
        .from("activities")
        .select("*")
        .eq("profil_id", id)
        .single();
    return activity;
  }

  Future<dynamic> getCurrentUserLastActivityDetails(String id) async {
    final lastActivity = await supabase
        .from("activities")
        .select("*")
        .eq("profile_id", id)
        .order("created_at", ascending: false)
        .limit(1)
        .single();

    print(lastActivity);

    return lastActivity;
  }
}
