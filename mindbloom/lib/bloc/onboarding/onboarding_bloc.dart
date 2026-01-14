import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/secure_storage_service.dart';
import '../../data/services/local_storage_service.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SecureStorageService _secureStorage;

  OnboardingBloc(this._secureStorage) : super(const OnboardingState(isLoading: true)) {

    on<CheckOnboardingStatus>((event, emit) async {
      final isDone = await _secureStorage.isOnboardingCompleted();
      emit(state.copyWith(isCompleted: isDone, isLoading: false));
    });

    on<PageChanged>((event, emit) {
      emit(state.copyWith(pageIndex: event.index));
    });

    on<OnboardingFinished>((event, emit) async {
      await _secureStorage.setOnboardingCompleted();
      emit(state.copyWith(isCompleted: true));
    });
  }
}
