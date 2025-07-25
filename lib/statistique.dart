import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatistiquesPage extends StatelessWidget {
  const StatistiquesPage({super.key});

  Future<Map<String, int>> fetchStats() async {
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    final ticketsSnapshot = await FirebaseFirestore.instance.collection('tickets').get();

    int apprenants = 0, formateurs = 0, admins = 0;
    for (var doc in usersSnapshot.docs) {
      final role = doc['role'];
      if (role == 'Apprenant') apprenants++;
      else if (role == 'Formateur') formateurs++;
      else if (role == 'Administrateur') admins++;
    }

    int attente = 0, enCours = 0, resolu = 0;
    for (var doc in ticketsSnapshot.docs) {
      final statut = doc['statut'];
      if (statut == 'En attente') attente++;
      else if (statut == 'En cours') enCours++;
      else if (statut == 'Résolu') resolu++;
    }

    return {
      'totalUsers': usersSnapshot.size,
      'apprenants': apprenants,
      'formateurs': formateurs,
      'admins': admins,
      'totalTickets': ticketsSnapshot.size,
      'attente': attente,
      'enCours': enCours,
      'resolu': resolu,
    };
  }

  Widget statCard(String label, int value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: ListTile(
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
        backgroundColor: Color(0xFF355E4B),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: fetchStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final stats = snapshot.data!;
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text('Utilisateurs', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              statCard('Total utilisateurs', stats['totalUsers']!, Colors.teal),
              statCard('Apprenants', stats['apprenants']!, Colors.blue),
              statCard('Formateurs', stats['formateurs']!, Colors.orange),
              statCard('Administrateurs', stats['admins']!, Colors.purple),
              SizedBox(height: 16),
              Text('Tickets', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              statCard('Total tickets', stats['totalTickets']!, Colors.teal),
              statCard('En attente', stats['attente']!, Colors.grey),
              statCard('En cours', stats['enCours']!, Colors.indigo),
              statCard('Résolus', stats['resolu']!, Colors.green),
            ],
          );
        },
      ),
    );
  }
}
