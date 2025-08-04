import 'mood_model.dart';

class JournalEntry {
  final String id;
  final DateTime date;
  final Mood mood;
  final String note;

  JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });
}
