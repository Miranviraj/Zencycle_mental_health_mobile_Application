import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Map<String, int> moodCounts = {};
  Map<String, double> habitProgressData = {};
  String mostCommonMood = '😐 Neutral';
  int streak = 0;

  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    fetchSummaryData();
  }

  Future<void> fetchSummaryData() async {
    if (userId == null) return;

    final now = DateTime.now();
    final last7Days = now.subtract(const Duration(days: 6));

    // ✅ Fetch mood data from user subcollection
    final moodSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('moods')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(last7Days))
        .get();

    Map<String, int> moods = {};
    for (var doc in moodSnapshot.docs) {
      final mood = doc['mood'];
      moods[mood] = (moods[mood] ?? 0) + 1;
    }

    // ✅ Most common mood
    String mostMood = '😐 Neutral';
    int max = 0;
    moods.forEach((key, value) {
      if (value > max) {
        max = value;
        mostMood = key;
      }
    });

    // ✅ Fetch habits from user subcollection
    final habitSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('habits')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(last7Days))
        .get();

    Map<String, int> total = {};
    Map<String, int> completed = {};

    for (var doc in habitSnapshot.docs) {
      final name = doc['title'];
      final done = doc['done'] ?? false;

      total[name] = (total[name] ?? 0) + 1;
      if (done) completed[name] = (completed[name] ?? 0) + 1;
    }

    Map<String, double> habitProgress = {};
    for (var key in total.keys) {
      habitProgress[key] = (completed[key] ?? 0) / total[key]!;
    }

    // Example streak logic — replace with real logic if needed
    int fakeStreak = 5;

    setState(() {
      moodCounts = moods;
      mostCommonMood = mostMood;
      habitProgressData = habitProgress;
      streak = fakeStreak;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weekly Summary")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mood Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            moodCounts.isEmpty
                ? const Text("No mood data available.")
                : AspectRatio(
              aspectRatio: 1.6,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final moodsList = moodCounts.keys.toList();
                          if (value.toInt() >= moodsList.length) return const SizedBox();
                          return Text(moodsList[value.toInt()], style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(moodCounts.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: moodCounts.values.elementAt(i).toDouble(),
                          color: Colors.deepPurple,
                          width: 15,
                        )
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text("Habit Completion", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (habitProgressData.isEmpty)
              const Text("No habit data available.")
            else
              for (var entry in habitProgressData.entries)
                habitProgress(entry.key, entry.value),

            const SizedBox(height: 30),
            const Text("Quick Stats", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            quickStat("Current Streak", "$streak days"),
            quickStat("Most Common Mood", mostCommonMood),
          ],
        ),
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
      leading: const Icon(Icons.check_circle, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
