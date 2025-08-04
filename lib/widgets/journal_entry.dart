import 'package:flutter/material.dart';
import '../models/journal_model.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;

  const JournalEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(entry.note),
        subtitle: Text('${entry.mood.name} • ${entry.date.toLocal()}'),
        leading: Icon(Icons.mood, color: Colors.deepPurple),
      ),
    );
  }
}
