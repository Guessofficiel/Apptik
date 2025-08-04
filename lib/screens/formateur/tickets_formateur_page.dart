import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class RepondreTicketPage extends StatelessWidget {
  final TextEditingController reponseController = TextEditingController();

  RepondreTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Répondre à un ticket')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Problème : Erreur d\'affichage'),
            TextField(
              controller: reponseController,
              decoration: InputDecoration(labelText: 'Réponse'),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: Text('Répondre')),
          ],
        ),
      ),
    );
  }
}
