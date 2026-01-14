import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {

    on<PageChanged>((event, emit) {
      emit(OnboardingState(pageIndex: event.index, isCompleted: false));
    });

    on<OnboardingFinished>((event, emit) {
      emit(OnboardingState(pageIndex: state.pageIndex, isCompleted: true));
    });
  }
}
