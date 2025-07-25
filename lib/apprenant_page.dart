import 'package:flutter/material.dart';
import 'package:apptik1/creatTik.dart';
import 'package:apptik1/appr_profil.dart';
// ...existing code...

class TicketCard extends StatelessWidget {
  final String num;
  final String title;
  final String status;

  const TicketCard({
    Key? key,
    required this.num,
    required this.title,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(num)),
        title: Text(title),
        subtitle: Text('Statut: $status'),
      ),
    );
  }
}

// ...existing code...
class AccueilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF355E4B),
        title: Text('APPTIK'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
  GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilPage(),
      )
      );
    },
    child: CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey[300],
      child: Icon(Icons.person, size: 30),
    ),
  ),
            SizedBox(height: 10),
            Text('Bienvenue, Thierno !', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
  onPressed: () { 
    Navigator.push(
      context,
  MaterialPageRoute(
    // Remplacez le Scaffold anonyme par la classe creationTicketPages
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
            TicketCard(num: '#234', title: 'Problème d’accès plateforme', status: 'En attente'),
            TicketCard(num: '#405', title: 'Vidéo bug - Chapitre 5', status: 'En cours'),
            TicketCard(num: '#125', title: 'Demande de correction devoir', status: 'Résolu'),
          ],
        ),
      ),
    );
  }
  
}
