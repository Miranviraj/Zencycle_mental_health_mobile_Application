import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback onChanged;

  const HabitTile({
    required this.title,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          onChanged: (_) => onChanged(),
          activeColor: Colors.deepPurple,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }
}
