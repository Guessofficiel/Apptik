import 'package:apptik1/admin_page.dart';
import 'package:apptik1/apprenant_page.dart';
import 'package:apptik1/profil_formateur_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

 Future<void> loginUser(BuildContext context) async {
  final String email = emailController.text.trim();
  final String password = passwordController.text.trim();

  print("Tentative de connexion avec : $email");

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs')),
    );
    print("Champs vides détectés");
    return;
  }

  try {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Connexion à Firebase Auth...")),
    );

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    print("Authentification réussie : ${userCredential.user!.uid}");

    // Récupération du rôle dans Firestore
    final uid = userCredential.user!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final role = userDoc.data()?['role'];
    print("Rôle récupéré : $role");

    if (role == 'apprenant') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Redirection vers Apprenant...")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AccueilPage()),
      );
    } else if (role == 'formateur') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Redirection vers Formateur...")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilFormateurPage()),
      );
    } else if (role == 'administrateur') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Redirection vers Admin...")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AccueilAdministrateurPage()),
      );
    } else {
      print("Rôle inconnu ou manquant");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Rôle inconnu")));
    }
  } on FirebaseAuthException catch (e) {
    String errorMsg = 'Erreur inconnue';

    if (e.code == 'user-not-found') {
      errorMsg = 'Aucun utilisateur trouvé avec cet email';
    } else if (e.code == 'wrong-password') {
      errorMsg = 'Mot de passe incorrect';
    }

    print("Erreur FirebaseAuth : ${e.code}");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorMsg)));
  } catch (e) {
    print("Erreur inattendue : $e");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(content: Text('Une erreur inattendue est survenue')),
    );
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
                'Welcome Back! 👋',
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
    onPressed: () {
      print("Bouton 'Se connecter' cliqué"); // Debug console
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connexion en cours...")),
      );
      loginUser(context);
    },
    child: const Text("Se connecter"),
  ),
),

          ],
        ),
      ),
    );
  }
}
