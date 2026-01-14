import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered whenever the user swipes or clicks "Next"
class PageChanged extends OnboardingEvent {
  final int index;

  const PageChanged(this.index);

  @override
  List<Object?> get props => [index];
}

/// Triggered when the user clicks "Skip" or "Get Started" on the last page
class OnboardingFinished extends OnboardingEvent {}
