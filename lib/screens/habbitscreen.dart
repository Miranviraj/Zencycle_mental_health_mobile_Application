import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/habbit.dart'; // Assumes you have HabitTile defined here

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
            'date': doc['date'] ?? Timestamp.now(),
          };
        }).toList();
        isLoading = false;
      });
    } else {
      // If no habits found, create some default ones
      final defaultHabits = [
        'Drink Water 💧',
        'Meditate 🧘‍♂️',
        'Read 15 mins 📚',
        'Go for a Walk 🚶‍♂️',
      ];

      for (var name in defaultHabits) {
        final docRef = await _firestore
            .collection('users')
            .doc(uid)
            .collection('habits')
            .add({
          'title': name,
          'done': false,
          'date': Timestamp.now(),
        });
        habits.add({
          'id': docRef.id,
          'title': name,
          'done': false,
          'date': Timestamp.now(),
        });
      }

      setState(() => isLoading = false);
    }
  }

  Future<void> toggleHabit(int index) async {
    final uid = _auth.currentUser!.uid;
    final updated = !habits[index]['done'];

    setState(() {
      habits[index]['done'] = updated;
    });

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habits[index]['id'])
        .update({'done': updated});
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Habit Tracker")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          // 🔹 Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/galaxy.jpg"),  
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Habit List on top
          ListView.builder(
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
        ],
      ),
    );
  }
}

