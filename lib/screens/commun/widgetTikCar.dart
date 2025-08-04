import 'package:flutter/material.dart';

class TicketCard extends StatefulWidget {
  final String num;
  final String title;
  final String status;

  const TicketCard({
    required this.num,
    required this.title,
    required this.status,
    super.key,
  });

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(widget.num)),
        title: Text(widget.title),
        subtitle: Text('Statut: ${widget.status}'),
      ),
    );
  }
}

class TicketCardStateless extends StatelessWidget {
  final String num;
  final String title;
  final String status;

  const TicketCardStateless({
    super.key,
    required this.num,
    required this.title,
    required this.status,
  });

  Color getStatusColor() {
    switch (status) {
      case 'En attente':
        return Colors.blueAccent;
      case 'En cours':
        return Colors.orangeAccent;
      case 'Résolu':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(num),
        trailing: Chip(label: Text(status), backgroundColor: getStatusColor()),
      ),
    );
  }
}
