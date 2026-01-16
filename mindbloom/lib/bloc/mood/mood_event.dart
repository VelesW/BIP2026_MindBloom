abstract class MoodEvent {}

class SaveMoodEvent extends MoodEvent {
  final String feeling;
  SaveMoodEvent(this.feeling);
}

class LoadLastMoodsEvent extends MoodEvent {}
