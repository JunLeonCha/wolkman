import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wolkman/services/auth-services.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  final AuthService _authService = AuthService();

  void toggleFormType() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;

      if (isLogin) {
        try {
          await _authService.signIn(email, password);
        } catch (e) {
          // Gérer les erreurs de connexion
          print('Erreur lors de la connexion : $e');
        }
      } else {
        final firstname = firstnameController.text;
        final lastname = lastnameController.text;

        try {
          // Inscription réussie, puis on réinitialise le formulaire
          await _authService.signUp(email, password, firstname, lastname);

          // Reset the form fields
          emailController.clear();
          passwordController.clear();
          firstnameController.clear();
          lastnameController.clear();

          // Switch to login mode
          setState(() {
            isLogin = true;
          });
        } catch (e) {
          // Gérer les erreurs d'inscription
          print('Erreur lors de l\'inscription : $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Connexion' : 'Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!isLogin) ...[
                TextFormField(
                  controller: firstnameController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prénom';
                    }
                    return null;
                  },
                ),
                Gap(16.0),
                TextFormField(
                  controller: lastnameController,
                  decoration: InputDecoration(labelText: 'Nom de famille'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom de famille';
                    }
                    return null;
                  },
                ),
                Gap(24.0),
              ],
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              Gap(16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              Gap(24.0),
              ElevatedButton(
                onPressed: submit,
                child: Text(isLogin ? 'Connexion' : 'Inscription'),
              ),
              TextButton(
                onPressed: toggleFormType,
                child: Text(isLogin
                    ? 'Pas encore de compte ? Inscrivez-vous'
                    : 'Déjà un compte ? Connectez-vous'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
