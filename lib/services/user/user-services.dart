import 'package:supabase_flutter/supabase_flutter.dart';

class UserServices {
  final SupabaseClient supabase = Supabase.instance.client;

  User? getCurrentUser() {
    try {
      return supabase.auth.currentUser;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    final userId = getCurrentUser()?.id;
    if (userId == null) return null; // Return null if userId is not found

    final response =
        await supabase.from("profiles").select("*").eq("id", userId).single();

    return response;
  }
}
