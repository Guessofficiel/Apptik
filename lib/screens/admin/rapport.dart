import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenererRapportPage extends StatelessWidget {
  const GenererRapportPage({super.key});

  Future<pw.Document> generatePdfReport() async {
    final doc = pw.Document();

    // Récupérer les utilisateurs
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();
    final ticketsSnapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .get();

    // Statistiques utilisateurs
    int apprenants = 0, formateurs = 0, admins = 0;
    for (var u in usersSnapshot.docs) {
      final role = u['role'];
      if (role == 'Apprenant') {
        apprenants++;
      } else if (role == 'Formateur')
        formateurs++;
      else if (role == 'Administrateur')
        admins++;
    }

    // Statistiques tickets
    int attente = 0, enCours = 0, resolu = 0;
    for (var t in ticketsSnapshot.docs) {
      final statut = t['statut'];
      if (statut == 'En attente') {
        attente++;
      } else if (statut == 'En cours')
        enCours++;
      else if (statut == 'Résolu')
        resolu++;
    }

    // Génération du contenu PDF
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Rapport d\'Activité - APPTIK')),
          pw.Paragraph(text: '📅 Date : ${DateTime.now().toString()}'),
          pw.SizedBox(height: 20),

          pw.Text(
            '👥 Statistiques des utilisateurs',
            style: pw.TextStyle(fontSize: 18),
          ),
          pw.Bullet(text: 'Apprenants : $apprenants'),
          pw.Bullet(text: 'Formateurs : $formateurs'),
          pw.Bullet(text: 'Administrateurs : $admins'),

          pw.SizedBox(height: 20),

          pw.Text(
            '🎫 Statistiques des tickets',
            style: pw.TextStyle(fontSize: 18),
          ),
          pw.Bullet(text: 'En attente : $attente'),
          pw.Bullet(text: 'En cours : $enCours'),
          pw.Bullet(text: 'Résolus : $resolu'),

          pw.SizedBox(height: 20),
          pw.Paragraph(
            text:
                'Fin du rapport. Généré automatiquement par l\'application APPTIK.',
          ),
        ],
      ),
    );

    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Générer un rapport"),
        backgroundColor: Color(0xFF355E4B),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final pdf = await generatePdfReport();
            await Printing.layoutPdf(onLayout: (format) => pdf.save());
          },
          icon: Icon(Icons.picture_as_pdf),
          label: Text("Générer le rapport PDF"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ),
    );
  }
}
