import 'package:apptik1/screens/commun/widgetTikCar.dart';
import 'package:flutter/material.dart';
import 'package:apptik1/screens/commun/creatTik.dart';
import 'package:apptik1/screens/apprenant/appr_profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  String? nom;
  String? email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        nom = doc.data()?['nom'] ?? '';
        email = user.email;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF355E4B), title: Text('APPTIK')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilPage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 30),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    nom != null && nom!.isNotEmpty
                        ? 'Bienvenue, $nom !'
                        : (email != null ? 'Bienvenue, $email !' : 'Bienvenue !'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // ...le reste de ton code inchangé...
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreationTicketPage(),
                        ),
                      );
                    },
                    child: Text('Créer un ticket'),
                  ),
                  SizedBox(height: 20),
                  Text('Mes tickets'),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('Technique')),
                      Chip(label: Text('Pédagogique')),
                      Chip(label: Text('Autre')),
                    ],
                  ),
                  SizedBox(height: 10),
                  TicketCard(
                    num: '#234',
                    title: 'Problème d’accès plateforme',
                    status: 'En attente',
                  ),
                  TicketCard(
                    num: '#405',
                    title: 'Vidéo bug - Chapitre 5',
                    status: 'En cours',
                  ),
                  TicketCard(
                    num: '#125',
                    title: 'Demande de correction devoir',
                    status: 'Résolu',
                  ),
                ],
              ),
      ),
    );
  }
}