import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/stats_repository.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final StatsRepository repository;

  StatsBloc({required this.repository}) : super(StatsInitial()) {
    on<LoadStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(LoadStats event, Emitter<StatsState> emit) async {
    emit(StatsLoading());
    try {
      final stats = await repository.getWellnessStats();
      emit(StatsLoaded(stats));
    } catch (e) {
      emit(StatsError("Failed to fetch statistics: ${e.toString()}"));
    }
  }
}
