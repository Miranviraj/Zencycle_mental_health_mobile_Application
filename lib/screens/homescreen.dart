import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'moodsscreen.dart';
import 'habbitscreen.dart';
import 'summary.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.email?.split('@').first ?? "User"; // Temporary display name

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        foregroundColor: Colors.blueGrey,
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white54,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Stack(
        children: [
          // 🔹 Background Image
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg3.jpg"), // or "assets/images/bg.jpg"
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // 🔹 Foreground Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello, $username 👋",
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),

                const SizedBox(height: 10),

                Text("Let’s build your habits and track your mood today!",
                    style: TextStyle(fontSize: 16, color: Colors.grey[200])),

                const SizedBox(height: 30),

                // Summary Box
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50]?.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text("📊 Weekly Summary",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      const SizedBox(height: 10),
                      Text("No data yet. Start logging moods & habits!",
                          style: TextStyle(color: Colors.blue[800])),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Shortcut Cards
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    _QuickActionCard(
                      icon: Icons.edit_note,
                      label: "Journal",
                      color: Colors.teal,
                      onTap: () {
                        Navigator.pushNamed(context, '/journalscreen');
                      },
                    ),
                    _QuickActionCard(
                      icon: Icons.auto_graph,
                      label: "Habits",
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pushNamed(context, '/habbitscreen');
                      },
                    ),
                    _QuickActionCard(
                      icon: Icons.emoji_emotions,
                      label: "Mood",
                      color: Colors.pinkAccent,
                      onTap: () {
                        Navigator.pushNamed(context, '/mood');
                      },
                    ),
                    _QuickActionCard(
                      icon: Icons.self_improvement,
                      label: "Breathe",
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.pushNamed(context, '/breathing');
                      },
                    ),
                    _QuickActionCard(
                      icon: Icons.spa,
                      label: "Meditation",
                      color: Colors.green,
                      onTap: () {
                        Navigator.pushNamed(context, '/meditation');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // Floating button for chatbot
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: Icon(Icons.chat),
        label: Text("MindBot"),
        onPressed: () {
          Navigator.pushNamed(context, '/chatbot');
        },
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            radius: 30,
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}
