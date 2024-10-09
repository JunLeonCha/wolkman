import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        // sign in succed
        Get.snackbar('Success', 'Connexion réussie avec l\'email: $email');
        Get.offNamed("/");
      }
    } on AuthException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Une erreur est survenue');
    }
  }

  Future<void> signUp(
      String email, String password, firstname, lastname) async {
    try {
      final display_name = '${firstname} ${lastname}';
      final response =
          await supabase.auth.signUp(email: email, password: password, data: {
        'firstname': firstname,
        'display_name': display_name,
        'lastname': lastname,
      });
      if (response.user != null) {
        // sign up succed
        Get.snackbar('Success', 'Inscription réussie avec l\'email: $email');
      }
    } on AuthException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Une erreur est survenue');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    Get.snackbar('Success', 'Déconnexion réussie');
    Get.offAllNamed("/sign_in");
  }
}
