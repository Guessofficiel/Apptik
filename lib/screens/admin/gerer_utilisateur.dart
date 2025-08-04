import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GererUtilisateursPage extends StatefulWidget {
  const GererUtilisateursPage({super.key});

  @override
  _GererUtilisateursPageState createState() => _GererUtilisateursPageState();
}

class _GererUtilisateursPageState extends State<GererUtilisateursPage> {
  String search = '';

  Future<void> updateStatut(String id, bool activer) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'statut': activer ? 'actif' : 'inactif',
    });
  }

  Future<void> deleteUser(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerer les utilisateurs'),
        backgroundColor: Color(0xFF355E4B),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un utilisateur...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() => search = value.toLowerCase());
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Nom",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Role",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Statut",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  final users = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['nom']?.toLowerCase() ?? '';
                    return name.contains(search);
                  }).toList();

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final data = user.data() as Map<String, dynamic>;
                      final id = user.id;
                      final nom = data['nom'] ?? '';
                      final role = data['role'] ?? '';
                      final statut = data['statut'] ?? 'inactif';

                      return Row(
                        children: [
                          Expanded(child: Text(nom)),
                          Expanded(child: Text(role)),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: statut == 'actif'
                                    ? Colors.green[100]
                                    : Colors.red[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statut == 'actif' ? 'Actif' : 'Inactif',
                                style: TextStyle(
                                  color: statut == 'actif'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // Naviguer vers une page de modification (à implémenter)
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    statut == 'actif'
                                        ? Icons.block
                                        : Icons.check_circle,
                                    color: statut == 'actif'
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                  onPressed: () =>
                                      updateStatut(id, statut != 'actif'),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteUser(id),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Ajouter un utilisateur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF355E4B),
              ),
              onPressed: () {
                // Naviguer vers une page d'ajout (à implémenter)
              },
            ),
          ],
        ),
      ),
    );
  }
}
