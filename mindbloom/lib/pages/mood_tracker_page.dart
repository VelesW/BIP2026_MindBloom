import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindbloom/data/datasource/mood_remote_ds.dart';
import 'package:mindbloom/data/repositories/mood_repository.dart';
import '../bloc/mood_bloc.dart';
import '../bloc/mood_event.dart';
import '../bloc/mood_state.dart';
import '../services/mistral_service.dart';
import 'mood_history_page.dart';

class MoodTrackerPage extends StatelessWidget {
  const MoodTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoodBloc(
        repository: MoodRepository(
          remoteDataSource: MoodRemoteDataSource(
            firestore: FirebaseFirestore.instance,
          ),
          mistral: MistralService(apiKey: "Rp99KgDxys8ScPPQv38enndUYnosEW9q"),
        ),
      ),
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

  String emotionFromValue(double value) {
    switch (value.round()) {
      case 1:
        return "Very Sad";
      case 2:
        return "Sad";
      case 3:
        return "Low";
      case 4:
        return "Neutral";
      case 5:
        return "Good";
      case 6:
        return "Happy";
      case 7:
        return "Very Happy";
      default:
        return "Neutral";
    }
  }

  String emojiForValue(double value) {
    switch (value.round()) {
      case 1:
        return "😭";
      case 2:
        return "😢";
      case 3:
        return "😕";
      case 4:
        return "😐";
      case 5:
        return "🙂";
      case 6:
        return "😄";
      case 7:
        return "🤩";
      default:
        return "😐";
    }
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // EMOJI
                Text(
                  emojiForValue(_moodValue),
                  style: const TextStyle(fontSize: 80),
                ),

                // SLIDER
                Slider(
                  value: _moodValue,
                  min: 1,
                  max: 7,
                  divisions: 6,
                  label: emotionFromValue(_moodValue),
                  onChanged: (value) {
                    setState(() => _moodValue = value);
                  },
                ),

                const SizedBox(height: 20),

                // SAVE MOOD BUTTON
                ElevatedButton(
                  onPressed: () {
                    context.read<MoodBloc>().add(
                      SaveMoodEvent(emotionFromValue(_moodValue)),
                    );
                  },
                  child: const Text("Save my Mood"),
                ),

                const SizedBox(height: 12),

                // LAST MOODS BUTTON (moved here)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<MoodBloc>(),
                          child: const MoodHistoryPage(),
                        ),
                      ),
                    );
                  },
                  child: const Text("See my previous Moods"),
                ),

                const SizedBox(height: 20),

                // AFFIRMATION CARD
                if (state is MoodSaved)
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Affirmation:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.affirmation,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const Spacer(),
              ],
            );
          },
        ),
      ),
    );
  }
}
