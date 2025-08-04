import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  NotificationsPage({super.key});

  Stream<QuerySnapshot> getUserNotifications() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _firestore
        .collection('notifications')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> supprimerNotification(String docId) async {
    await _firestore.collection('notifications').doc(docId).delete();
  }

  Future<void> marquerCommeLue(String docId) async {
    await _firestore.collection('notifications').doc(docId).update({
      'lu': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF355E4B),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return Center(child: Text("Aucune notification disponible"));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;
              final message = data['message'] ?? '';
              final timestamp = data['timestamp']?.toDate();
              final isRead = data['lu'] ?? false;

              return Card(
                color: isRead ? Colors.white : Color(0xFFE8F5E9),
                child: ListTile(
                  title: Text(
                    message,
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: timestamp != null
                      ? Text(
                          '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      : null,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'supprimer') {
                        await supprimerNotification(doc.id);
                      } else if (value == 'lu') {
                        await marquerCommeLue(doc.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'lu',
                        child: Text('Marquer comme lue'),
                      ),
                      PopupMenuItem(
                        value: 'supprimer',
                        child: Text('Supprimer'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
