import 'package:flutter/material.dart';
import 'package:apptik1/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final user = await _authService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        // Récupère le rôle depuis Firestore
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final role = doc.data()?['role'] ?? '';
        if (!mounted) return;
       // ...dans _login()
if (role == 'Apprenant') {
  print('Redirection vers /apprenant');
  context.go('/apprenant');
} else if (role == 'Formateur') {
  print('Redirection vers /formateur');
  context.go('/formateur');
} else if (role == 'Admin' || role == 'Administrateur') {
  print('Redirection vers /admin');
  context.go('/admin');
} else {
  setState(() {
    errorMessage = 'Rôle utilisateur inconnu.';
  });
}
      } else if (user == null) {
        setState(() {
          errorMessage = 'Identifiants invalides.';
        });
      } else {
        setState(() {
          errorMessage = 'Utilisateur non trouvé.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryColor = Color(0xFF355E4B);
    const Color kTextFieldColor = Color(0xFF4F7F68);
    const Color kButtonColor = Colors.black;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Welcome Back! ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Center(
              child: Text(
                'APPTIK',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Connexion',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: kTextFieldColor,
                hintText: 'Entrez votre Email',
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: kTextFieldColor,
                hintText: 'Entrez votre mot de passe',
                hintStyle: const TextStyle(color: Colors.white70),
                suffixIcon: const Icon(
                  Icons.visibility_off,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kButtonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: isLoading ? null : _login,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Se connecter"),
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}