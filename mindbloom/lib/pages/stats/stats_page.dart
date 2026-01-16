import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/stats/stats_bloc.dart';
import '../../bloc/stats/stats_event.dart';
import '../../bloc/stats/stats_state.dart';
import '../../data/models/wellness_stats.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulness Stats'),
        centerTitle: true,
      ),
      body: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          if (state is StatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StatsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainScore(context, state.stats),
                  const SizedBox(height: 32),
                  const Text(
                    "Weekly Consistency",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildActivityChart(context, state.stats.weeklyActivity),
                  const SizedBox(height: 32),
                  _buildStatRow(
                    context,
                    "Current Streak",
                    "${state.stats.currentStreak} Days",
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                  _buildStatRow(
                    context,
                    "Average Mood",
                    state.stats.averageMood.toStringAsFixed(1),
                    Icons.face_retouching_natural,
                    Colors.blue,
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("Start journaling to see your stats!"));
        },
      ),
    );
  }

  Widget _buildMainScore(BuildContext context, WellnessStats stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Text(
            "Total Sessions",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          Text(
            "${stats.totalJournals}",
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
          const Text("Mindful moments captured"),
        ],
      ),
    );
  }

  Widget _buildActivityChart(BuildContext context, List<double> data) {
    return Container(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((value) {
          return Container(
            width: 35,
            height: 120 * value,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
