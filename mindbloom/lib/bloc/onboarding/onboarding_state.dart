import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int pageIndex;
  final bool isCompleted;
  final bool isLoading; // Handle the async secure storage read

  const OnboardingState({
    this.pageIndex = 0,
    this.isCompleted = false,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [pageIndex, isCompleted, isLoading];

  // Helper method for easy state copying
  OnboardingState copyWith({
    int? pageIndex,
    bool? isCompleted,
    bool? isLoading,
  }) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
