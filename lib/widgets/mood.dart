import 'package:flutter/material.dart';
import '../models/mood_model.dart';

class MoodSelector extends StatelessWidget {
  final Mood selectedMood;
  final Function(Mood) onMoodSelected;

  const MoodSelector({required this.selectedMood, required this.onMoodSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: Mood.values.map((mood) {
        return IconButton(
          icon: Icon(
            Icons.mood,
            color: selectedMood == mood ? Colors.deepPurple : Colors.grey,
          ),
          onPressed: () => onMoodSelected(mood),
        );
      }).toList(),
    );
  }
}
