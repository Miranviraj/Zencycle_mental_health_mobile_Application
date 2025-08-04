import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/journal_model.dart';
import '../models/mood_model.dart';

class MoodChart extends StatelessWidget {
  final List<JournalEntry> entries;

  const MoodChart({required this.entries});

  double _moodToY(Mood mood) {
    switch (mood) {
      case Mood.happy:
        return 5;
      case Mood.neutral:
        return 3;
      case Mood.sad:
        return 1;
      case Mood.anxious:
        return 2;
      case Mood.angry:
        return 0;
    }
  }

  String _yToLabel(double y) {
    switch (y.toInt()) {
      case 5:
        return "😊";
      case 3:
        return "😐";
      case 2:
        return "😰";
      case 1:
        return "😢";
      case 0:
        return "😡";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final spots = entries.asMap().entries.map((entry) {
      final index = entry.key;
      final journal = entry.value;
      return FlSpot(index.toDouble(), _moodToY(journal.mood));
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 5,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => Text(_yToLabel(value)),
                interval: 1,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.deepPurple,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
