import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/journal_repository.dart';
import 'journal_event.dart';
import 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository _repository;

  JournalBloc(this._repository) : super(JournalInitial()) {
    // Handle saving
    on<AddJournalEntry>((event, emit) async {
      try {
        await _repository.saveJournalEntry(event.content);
        // We don't need to emit a 'loaded' state here if we use a Stream
      } catch (e) {
        emit(JournalError(e.toString()));
      }
    });

    // Handle initial load
    on<LoadJournals>((event, emit) async {
      emit(JournalLoading());
      await emit.forEach(
        _repository.getJournalStream(),
        onData: (data) => JournalLoaded(data),
        onError: (error, stackTrace) => JournalError(error.toString()),
      );
    });
  }
}
