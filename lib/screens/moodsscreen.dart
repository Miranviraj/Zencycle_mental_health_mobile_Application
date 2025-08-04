import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MoodScreen extends StatefulWidget {
  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? selectedMood;
  final noteController = TextEditingController();
  final moods = ['😊 Happy', '😢 Sad', '😠 Angry', '😐 Neutral', '😴 Tired'];

  Future<void> saveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a mood")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      final moodRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('moods')
          .doc(); // Auto-ID

      await moodRef.set({
        'mood': selectedMood,
        'note': noteController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid, // For debugging/view
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mood saved successfully!")),
      );

      setState(() {
        selectedMood = null;
        noteController.clear();
      });
    } catch (e) {
      print("🔥 Firestore Save Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving mood: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("How are you feeling?")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select your mood:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: moods.map((mood) {
                final isSelected = mood == selectedMood;
                return ChoiceChip(
                  label: Text(mood),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedMood = mood),
                  selectedColor: Colors.deepPurple,
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: "Optional note",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: saveMood,
              icon: Icon(Icons.save),
              label: Text("Save Mood"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
