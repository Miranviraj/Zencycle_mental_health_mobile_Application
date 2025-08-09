import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save journal entry for current user
  Future<void> addJournalEntry(String text, DateTime date) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('journals')
        .add({
      'text': text,
      'date': date,
    });
  }

  // Save habit for current user
  Future<void> addHabit(String title, bool completed) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .add({
      'title': title,
      'completed': completed,
      'created_at': DateTime.now(),
    });
  }

  // Stream journal entries
  Stream<QuerySnapshot> journalEntriesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('journals')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Stream habits
  Stream<QuerySnapshot> habitsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<void> updateJournalEntry(String id, String newText) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('journal_entries')
        .doc(id)
        .update({'text': newText});
  }

  Future<void> deleteJournalEntry(String id) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('journal_entries')
        .doc(id)
        .delete();
  }
}
