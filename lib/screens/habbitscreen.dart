import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/habbit.dart';

class HabitScreen extends StatefulWidget {
  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> habits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final uid = _auth.currentUser!.uid;
    final habitSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .get();

    if (habitSnapshot.docs.isNotEmpty) {
      setState(() {
        habits = habitSnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'title': doc['title'],
            'done': doc['done'],
          };
        }).toList();
        isLoading = false;
      });
    } else {
      // default if no data in Firestore yet
      habits = [
        {'title': 'Drink Water 💧', 'done': false},
        {'title': 'Meditate 🧘‍♂️', 'done': false},
        {'title': 'Read for 15 mins 📚', 'done': false},
        {'title': 'Go for a Walk 🚶‍♂️', 'done': false},
      ];
      // Save them to Firestore
      for (var habit in habits) {
        var doc = await _firestore
            .collection('users')
            .doc(uid)
            .collection('habits')
            .add({
          'title': habit['title'],
          'done': habit['done'],
        });
        habit['id'] = doc.id;
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleHabit(int index) async {
    final uid = _auth.currentUser!.uid;
    setState(() {
      habits[index]['done'] = !habits[index]['done'];
    });

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habits[index]['id'])
        .update({'done': habits[index]['done']});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Habit Tracker")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          return HabitTile(
            title: habits[index]['title'],
            isCompleted: habits[index]['done'],
            onChanged: () => toggleHabit(index),
          );
        },
      ),
    );
  }
}
