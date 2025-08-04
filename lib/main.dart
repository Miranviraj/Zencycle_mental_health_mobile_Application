import 'package:flutter/material.dart';
import 'package:untitled13/screens/meditation.dart';
import 'package:untitled13/screens/moodsscreen.dart';
import 'screens/habbitscreen.dart';
import 'screens/homescreen.dart';
import 'screens/journalscreen.dart';
import 'screens/main_screen.dart';
import 'screens/summary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/moodsscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/chatbot.dart';
import 'screens/breathing_screen.dart';
import 'screens/meditation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MindTrackApp());
}

class MindTrackApp extends StatelessWidget {
  const MindTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindTrack',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/mood': (context) =>  MoodScreen(),
        '/habbitscreen': (context) => HabitScreen(),
        '/journalscreen': (context) => const JournalPage(),
        '/summary': (context) => const SummaryScreen(),
        '/chatbot': (context) => ChatbotScreen(),
        '/breathing': (context) => BreathingScreen(),
        '/meditation': (context) => MeditationScreen(),
      }, // initial screen
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final screens = [
    HomeScreen(),
    HabitScreen(),
    JournalPage(),
    SummaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },


        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Summary'),
        ],
      ),
    );
  }
}
