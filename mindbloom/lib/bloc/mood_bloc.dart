import 'package:flutter_bloc/flutter_bloc.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  MoodBloc() : super(MoodInitial()) {
    on<SaveMoodEvent>(_onSaveMood);
  }

  Future<void> _onSaveMood(SaveMoodEvent event, Emitter<MoodState> emit) async {
    emit(MoodSaving());

    try {
      // TODO: Save to Firestore
      // TODO: Call Mistral AI

      await Future.delayed(const Duration(seconds: 1)); // simulate work

      emit(MoodSaved("Your affirmation will appear here."));
    } catch (e) {
      emit(MoodError("Failed to save mood"));
    }
  }
}
