abstract class WellnessHomeState {}

class WellnessHomeInitial extends WellnessHomeState {}

class WellnessHomeLoading extends WellnessHomeState {}

class WellnessHomeLoaded extends WellnessHomeState {
  final String greeting;
  final String imageAssetPath;

  WellnessHomeLoaded({required this.greeting, required this.imageAssetPath});
}
