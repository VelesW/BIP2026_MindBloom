import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/mood_bloc.dart';
import '../bloc/mood_event.dart';
import '../bloc/mood_state.dart';

class MoodHistoryPage extends StatelessWidget {
  const MoodHistoryPage({super.key});

  // Convert feeling string → emoji
  String emojiForFeeling(String feeling) {
    switch (feeling) {
      case "Very Sad":
        return "😭";
      case "Sad":
        return "😢";
      case "Low":
        return "😕";
      case "Neutral":
        return "😐";
      case "Good":
        return "🙂";
      case "Happy":
        return "😄";
      case "Very Happy":
        return "🤩";
      default:
        return "😐";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Last Moods")),
      body: BlocProvider.value(
        value: context.read<MoodBloc>()..add(LoadLastMoodsEvent()),
        child: BlocBuilder<MoodBloc, MoodState>(
          builder: (context, state) {
            if (state is MoodLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MoodHistoryLoaded) {
              final moods = state.moods;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: moods.length,
                itemBuilder: (_, i) {
                  final mood = moods[i];
                  final emoji = emojiForFeeling(mood.feeling);

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DATE
                          Text(
                            "${mood.createdAt.toLocal()}".split(".")[0],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // FEELING + EMOJI
                          Row(
                            children: [
                              Text(emoji, style: const TextStyle(fontSize: 32)),
                              const SizedBox(width: 12),
                              Text(
                                mood.feeling,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // AFFIRMATION LABEL
                          Text(
                            "Affirmation:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // AFFIRMATION TEXT
                          Text(
                            mood.affirmation,
                            style: const TextStyle(
                              fontSize: 17,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(child: Text("No moods found"));
          },
        ),
      ),
    );
  }
}
