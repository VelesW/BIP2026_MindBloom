import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int pageIndex;
  final bool isCompleted;

  const OnboardingState({this.pageIndex = 0, this.isCompleted = false});

  @override
  List<Object> get props => [pageIndex, isCompleted];
}
