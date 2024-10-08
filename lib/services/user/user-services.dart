import 'package:supabase_flutter/supabase_flutter.dart';

class UserServices {
  final SupabaseClient supabase = Supabase.instance.client;

  User? getCurrentUser() {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
}
