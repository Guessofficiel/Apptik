import 'package:flutter/material.dart';

class AccueilAdministrateurPage extends StatelessWidget {
  final List<Map<String, dynamic>> tickets = [
    {'num': '#234', 'title': 'Problème d’accès plateforme', 'status': 'En attente'},
    {'num': '#405', 'title': 'Vidéo bug – Chapitre 5', 'status': 'En cours'},
    {'num': '#125', 'title': 'Demande de correction devoir', 'status': 'Résolu'},
  ];

  AccueilAdministrateurPage({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case 'En attente':
        return Colors.blueGrey;
      case 'En cours':
        return Colors.blue;
      case 'Résolu':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('APPTIK', style: TextStyle(color: Color(0xFF355E4B))),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF355E4B),
                    radius: 24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SOW Mohamed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Administrateur', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16),
              Text('Bienvenue, Mohamed!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              // Barre de recherche
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un ticket...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 254, 254, 254),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Center(child: Text('Tous les tickets')),
              ),

              SizedBox(height: 20),
              Text('Les tickets', style: TextStyle(fontWeight: FontWeight.bold)),

              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text('Technique')),
                  Chip(label: Text('Pédagogique')),
                ],
              ),

              SizedBox(height: 16),

              // Liste des tickets
              Column(
                children: tickets.map((ticket) {
                  return Card(
                    elevation: 1,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Text(ticket['num'].replaceAll('#', '')),
                      ),
                      title: Text(ticket['title']),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(ticket['status']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ticket['status'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),

              // Liens admin
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Text('Gerer les utilisateurs', style: TextStyle(color: Color(0xFF355E4B))),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () {},
                    child: Text('Voir les statistiques', style: TextStyle(color: Color(0xFF355E4B))),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () {},
                    child: Text('Generer des rapports', style: TextStyle(color: Color(0xFF355E4B))),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
