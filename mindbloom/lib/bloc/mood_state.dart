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
