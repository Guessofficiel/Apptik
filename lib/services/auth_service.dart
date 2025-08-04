import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Inscription
  Future<User?> signUp(String name, String email, String password, String phone, String role) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'nom': name,
      'email': email,
      'phone': phone,
      'role': role,
    });
    return credential.user;
  }

  // Connexion
  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}