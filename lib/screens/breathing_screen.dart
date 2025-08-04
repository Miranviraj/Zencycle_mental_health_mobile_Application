import 'package:flutter/material.dart';
import 'dart:async';

class BreathingScreen extends StatefulWidget {
  @override
  _BreathingScreenState createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _instruction = "Breathe In";
  Timer? _textTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..forward();


    _animation = Tween<double>(begin: 100, end: 200).animate(_controller);

    _startTextLoop();
  }

  void _startTextLoop() {
    _textTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        if (_instruction == "Breathe In") {
          _instruction = "Hold...";
          _controller.stop(); // Pause animation during Hold
        } else if (_instruction == "Hold...") {
          _instruction = "Breathe Out";
          _controller.reverse(); // Resume animation
        } else {
          _instruction = "Breathe In";
          _controller.forward();// Resume animation in reverse
        }
      });
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    _textTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Guided Breathing")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizedBox(
                  height: _animation.value,
                  width: _animation.value,
                  child: Image.asset(
                    'assets/heart.png', // make sure this asset exists and is declared in pubspec.yaml
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              _instruction,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Follow the animation to relax"),
          ],
        ),
      ),
    );
  }
}
