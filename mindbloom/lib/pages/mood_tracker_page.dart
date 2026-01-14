import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/mood_bloc.dart';
import '../bloc/mood_event.dart';
import '../bloc/mood_state.dart';

class MoodTrackerPage extends StatelessWidget {
  const MoodTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoodBloc(),
      child: const _MoodTrackerView(),
    );
  }
}

class _MoodTrackerView extends StatefulWidget {
  const _MoodTrackerView();

  @override
  State<_MoodTrackerView> createState() => _MoodTrackerViewState();
}

class _MoodTrackerViewState extends State<_MoodTrackerView> {
  double _moodValue = 5;

  String _emojiForMood(double value) {
    if (value <= 2) return "😢";
    if (value <= 4) return "😕";
    if (value <= 6) return "😐";
    if (value <= 8) return "🙂";
    return "😄";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<MoodBloc, MoodState>(
          listener: (context, state) {
            if (state is MoodSaved) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Mood saved")));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Text(
                  _emojiForMood(_moodValue),
                  style: const TextStyle(fontSize: 80),
                ),

                Slider(
                  value: _moodValue,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _moodValue.round().toString(),
                  onChanged: (value) {
                    setState(() => _moodValue = value);
                  },
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    context.read<MoodBloc>().add(
                      SaveMoodEvent(_moodValue.toInt()),
                    );
                  },
                  child: const Text("Save Mood"),
                ),

                const SizedBox(height: 20),

                if (state is MoodSaved)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(state.affirmation, textAlign: TextAlign.center),
                  ),

                const Spacer(),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/moodHistory");
                  },
                  child: const Text("View last 10 moods"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
