import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mood Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(days[value.toInt()]);
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  for (int i = 0; i < 7; i++)
                    BarChartGroupData(x: i, barRods: [
                      BarChartRodData(toY: (i + 1).toDouble(), color: Colors.deepPurple, width: 15)
                    ])
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
          Text("Habit Completion", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          habitProgress("Wake Up Early", 0.8),
          habitProgress("Exercise", 0.6),
          habitProgress("Meditate", 0.4),
          habitProgress("No Junk Food", 0.9),

          const SizedBox(height: 30),
          Text("Quick Stats", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          quickStat("Current Streak", "5 days"),
          quickStat("Most Common Mood", "😊 Happy"),
        ],
      ),
    );
  }

  Widget habitProgress(String title, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[300],
          color: Colors.deepPurple,
          minHeight: 10,
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget quickStat(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.check_circle, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
