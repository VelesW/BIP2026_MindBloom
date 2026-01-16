import 'package:flutter/material.dart';
import 'dart:async';

// Definition der verschiedenen Phasen der Übung
enum ExercisePhase {start, preparation, inhale, exhale, sensing, finished }

class BreathExercisePage extends StatefulWidget {
  const BreathExercisePage({super.key});

  @override
  State<BreathExercisePage> createState() => _BreathExercisePageState();
}

class _BreathExercisePageState extends State<BreathExercisePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  Timer? _timer;
  ExercisePhase _currentPhase = ExercisePhase.start;
  int _secondsRemaining = 0;
  int _totalRepetitionSeconds = 120; 
  bool _isStarted = false;

  
  final int _prepTime = 2;
  final int _inhaleTime = 4;
  final int _exhaleTime = 6;
  final int _sensingTime = 10;

  @override
  void initState() {
    super.initState();
    // controls size of the circle
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _inhaleTime),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _startExercise() {
    setState(() {
      _isStarted = true;
      _totalRepetitionSeconds = 120; // Reset 2 Min
      _updatePhase(ExercisePhase.preparation);
    });
  }

  void _updatePhase(ExercisePhase newPhase) {
    _timer?.cancel();
    setState(() => _currentPhase = newPhase);

    switch (newPhase) {
      case ExercisePhase.start:
        _secondsRemaining = 0;
        _animationController.stop();
        break;
      case ExercisePhase.preparation:
        _secondsRemaining = _prepTime;
        _animationController.stop(); // no pulse during preparation
        break;
      case ExercisePhase.inhale:
        _secondsRemaining = _inhaleTime;
        _animationController.duration = Duration(seconds: _inhaleTime);
        _animationController.forward(); // circle gets bigger
        break;
      case ExercisePhase.exhale:
        _secondsRemaining = _exhaleTime;
        _animationController.duration = Duration(seconds: _exhaleTime);
        _animationController.reverse(); // circle gets smaller
        break;
      case ExercisePhase.sensing:
        _secondsRemaining = _sensingTime;
        _animationController.stop();
        break;
      case ExercisePhase.finished:
        _isStarted = false;
        _secondsRemaining = 0;
        _animationController.stop();
        break;
    }

    // start timer for the current phase
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 1) {
          _secondsRemaining--;
          // 
          if (_currentPhase == ExercisePhase.inhale || _currentPhase == ExercisePhase.exhale) {
            _totalRepetitionSeconds--;
          }
        } else {
          _moveToNextPhase();
          _totalRepetitionSeconds--;
        }
      });
    });
  }

  void _moveToNextPhase() {
      if (_currentPhase == ExercisePhase.start) {
      _updatePhase(ExercisePhase.preparation);
    } else if (_currentPhase == ExercisePhase.preparation) {
      _updatePhase(ExercisePhase.inhale);
    } else if (_currentPhase == ExercisePhase.inhale) {
      _updatePhase(ExercisePhase.exhale);
    } else if (_currentPhase == ExercisePhase.exhale) {
      // check if total time is up
      if (_totalRepetitionSeconds <= 0) {
        _updatePhase(ExercisePhase.sensing);
      } else {
        _updatePhase(ExercisePhase.inhale);
      }
    } else if (_currentPhase == ExercisePhase.sensing) {
      _updatePhase(ExercisePhase.finished);
    }
  }

  String _getPhaseText() {
    switch (_currentPhase) {
      case ExercisePhase.start: return "Get Ready";
      case ExercisePhase.preparation: return "Preparation\n";
      case ExercisePhase.inhale: return "Breath in\n(Nose)";
      case ExercisePhase.exhale: return "Breath out\n(Mouth)";
      case ExercisePhase.sensing: return "Sensing\n(Normal breathing)";
      case ExercisePhase.finished: return "Finished";
      
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF1A1A2E),
    body: Stack( 
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 54, 54, 104), Color(0xFF4A148C)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 60), 
              Text(
                _getPhaseText(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w300),
              ),
              
              // pulsating circle 
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepPurpleAccent.withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurpleAccent.withOpacity(0.3),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$_secondsRemaining',
                          style: const TextStyle(fontSize: 70, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Start Button
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: _isStarted 
                  ? Text(
                      "Time remaining: ${_totalRepetitionSeconds > 0 ? _totalRepetitionSeconds : 0}s",
                      style: const TextStyle(color: Colors.white60),
                    )
                  : ElevatedButton(
                      onPressed: _startExercise,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        elevation: 10,
                      ),
                      child: const Text("START", style: TextStyle(fontSize: 20, letterSpacing: 1.5)),
                    ),
              ),
            ],
          ),
        ),

        // zrück button
        Positioned(
          top: 0,
          left: 0,
          child: SafeArea( 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(), 
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), 
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}