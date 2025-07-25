import 'package:apptik1/answerTik.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profil_formateur_page.dart';  // Crée-le si besoin

class AccueilFormateurPage extends StatelessWidget {
  const AccueilFormateurPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryColor = Color(0xFF355E4B);
    const Color kButtonColor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Espace Formateur'),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilFormateurPage ()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 30),
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Bienvenue Formateur !',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kButtonColor,
                minimumSize: Size(double.infinity, 50),
              ),
              icon: Icon(Icons.receipt_long),
              label: Text("Répondre aux tickets"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>RepondreTicketPage()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
              ),
              icon: Icon(Icons.bar_chart),
              label: Text("Voir les statistiques"),
              onPressed: () {
                // TODO: Naviguer vers une future page statistiques
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Bientôt disponible")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
