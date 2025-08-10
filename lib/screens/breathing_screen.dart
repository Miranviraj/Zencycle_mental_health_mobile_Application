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
    )
      ..forward();


    _animation = Tween<double>(begin: 100, end: 200).animate(_controller);

    _startTextLoop();
  }

  void _startTextLoop() {
    _textTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        if (_instruction == "Breathe In") {
          _instruction = "Hold...";
          _controller.stop();
        } else if (_instruction == "Hold...") {
          _instruction = "Breathe Out";
          _controller.reverse();
        } else {
          _instruction = "Breathe In";
          _controller.forward();
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
      appBar: AppBar(title: Text("Guided Breathing"),
       backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor:Colors.white),
      body: Stack(
        children: [
      
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg2.jpg"),
                
                fit: BoxFit.cover,
              ),
            ),
          ),

          
          Center(
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
                        'assets/heart.png',
                      
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Text(
                  _instruction,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Follow the animation to relax",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
