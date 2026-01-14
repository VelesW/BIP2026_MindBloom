import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/mood_repository.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final MoodRepository repository;

  MoodBloc({required this.repository}) : super(MoodInitial()) {
    on<SaveMoodEvent>(_onSaveMood);
    on<LoadLastMoodsEvent>(_onLoadLastMoods);
  }

  Future<void> _onSaveMood(SaveMoodEvent event, Emitter<MoodState> emit) async {
    emit(MoodSaving());

    try {
      final mood = await repository.saveMood(feeling: event.feeling);

      emit(MoodSaved(mood.affirmation));
    } catch (e) {
      emit(MoodError("Failed to save mood"));
    }
  }

  Future<void> _onLoadLastMoods(
    LoadLastMoodsEvent event,
    Emitter<MoodState> emit,
  ) async {
    emit(MoodLoading());

    try {
      final moods = await repository.getLast10Moods();
      emit(MoodHistoryLoaded(moods));
    } catch (e) {
      emit(MoodError("Failed to load moods"));
    }
  }
}
