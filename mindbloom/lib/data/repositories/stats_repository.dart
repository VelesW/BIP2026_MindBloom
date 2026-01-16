import '../models/wellness_stats.dart';

class StatsRepository {
  Future<WellnessStats> getWellnessStats() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return const WellnessStats(
      totalJournals: 14,
      currentStreak: 5,
      averageMood: 4.8,
      weeklyActivity: [0.3, 0.6, 0.4, 0.8, 0.5, 0.7, 0.9],
    );
  }
}
