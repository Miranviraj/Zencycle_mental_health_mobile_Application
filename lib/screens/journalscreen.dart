import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController _textController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  void _addEntry() async {
    if (_textController.text.isNotEmpty) {
      try {
        await firestoreService.addJournalEntry(_textController.text, DateTime.now());
        _textController.clear();
      } catch (e) {
        print('Error adding entry: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save entry. Please check your connection.')),
        );
      }
    }
  }

  Future<void> addJournalEntry(String text, DateTime date) async {
    await FirebaseFirestore.instance.collection('journal_entries').add({
      'text': text,
      'date': date,
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Journal")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: "What's on your mind?",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addEntry,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.journalEntriesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final entries = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return ListTile(
                      title: Text(entry['text']),
                      subtitle: Text(entry['date'].toDate().toString()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
