import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/mood_bloc.dart';
import '../bloc/mood_event.dart';
import '../bloc/mood_state.dart';

class MoodHistoryPage extends StatelessWidget {
  const MoodHistoryPage({super.key});

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
                itemCount: moods.length,
                itemBuilder: (_, i) {
                  final mood = moods[i];
                  return ListTile(
                    leading: Text(
                      mood.feeling,
                      style: const TextStyle(fontSize: 20),
                    ),
                    title: Text(mood.affirmation),
                    subtitle: Text(mood.createdAt.toString()),
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
