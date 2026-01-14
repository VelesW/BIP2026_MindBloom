import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class CheckOnboardingStatus extends OnboardingEvent {}

class PageChanged extends OnboardingEvent {
  final int index;

  const PageChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class OnboardingFinished extends OnboardingEvent {}
