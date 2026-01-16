import 'package:equatable/equatable.dart';

class WellnessStats extends Equatable {
  final int totalJournals;
  final int currentStreak;
  final double averageMood;
  final List<double> weeklyActivity;

  const WellnessStats({
    required this.totalJournals,
    required this.currentStreak,
    required this.averageMood,
    required this.weeklyActivity,
  });

  @override
  List<Object> get props => [totalJournals, currentStreak, averageMood, weeklyActivity];
}
