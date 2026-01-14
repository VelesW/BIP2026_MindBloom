import 'package:mindbloom/data/models/mood.dart';

abstract class MoodState {}

class MoodInitial extends MoodState {}

class MoodSaving extends MoodState {}

class MoodSaved extends MoodState {
  final String affirmation;
  MoodSaved(this.affirmation);
}

class MoodError extends MoodState {
  final String message;
  MoodError(this.message);
}

class MoodLoading extends MoodState {}

class MoodHistoryLoaded extends MoodState {
  final List<Mood> moods;
  MoodHistoryLoaded(this.moods);
}
