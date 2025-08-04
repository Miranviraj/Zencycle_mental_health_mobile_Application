class Habit {
  final String id;
  final String title;
  bool isCompleted;
  final DateTime date;

  Habit({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.date,
  });
}
