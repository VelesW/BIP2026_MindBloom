abstract class MoodEvent {}

class SaveMoodEvent extends MoodEvent {
  final int feeling;
  SaveMoodEvent(this.feeling);
}
