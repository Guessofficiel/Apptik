import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class CreationTicketPage extends StatefulWidget {
  const CreationTicketPage({super.key});

  @override
  State<CreationTicketPage> createState() => _CreationTicketPageState();
}

class _CreationTicketPageState extends State<CreationTicketPage> {
  String? selectedCategory;
  final TextEditingController descriptionController = TextEditingController();
  String? errorMsg;
  bool isSubmitting = false;

  final List<String> categories = ['Technique', 'Pédagogique', 'Autre'];

  Future<void> _creerTicket() async {
    setState(() {
      errorMsg = null;
      isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Utilisateur non connecté");
      }

      if (selectedCategory == null || descriptionController.text.trim().isEmpty) {
        throw Exception("Veuillez remplir tous les champs");
      }

      // Récupérer le dernier numéro
      final snapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      int newNumber = 1;
      if (snapshot.docs.isNotEmpty) {
        final last = snapshot.docs.first.data();
        final lastNum = last['numero'];
        final numOnly = int.tryParse(lastNum.toString().replaceAll('#', ''));
        if (numOnly != null) {
          newNumber = numOnly + 1;
        }
      }

      // Ajouter le ticket
      await FirebaseFirestore.instance.collection('tickets').add({
        'categorie': selectedCategory,
        'description': descriptionController.text.trim(),
        'uid': user.uid,
        'statut': 'En attente',
        'numero': '#${newNumber.toString().padLeft(3, '0')}',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // Affichage SnackBar + redirection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Ticket créé avec succès')),
      );

      await Future.delayed(const Duration(seconds: 1));
      context.go('/apprenant');
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Erreur : ${e.toString()}')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un ticket'),
        backgroundColor: const Color(0xFF355E4B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Catégorie', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Description', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Décrivez votre problème...',
              ),
            ),
            const SizedBox(height: 20),
            if (errorMsg != null)
              Text(errorMsg!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _creerTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF355E4B),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Créer le ticket'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
