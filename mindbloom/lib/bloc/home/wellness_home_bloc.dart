import 'package:flutter_bloc/flutter_bloc.dart';
import 'wellness_home_event.dart';
import 'wellness_home_state.dart';

export 'wellness_home_event.dart';
export 'wellness_home_state.dart';

class WellnessHomeBloc extends Bloc<WellnessHomeEvent, WellnessHomeState> {
  WellnessHomeBloc() : super(WellnessHomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  void _onLoadHomeData(LoadHomeData event, Emitter<WellnessHomeState> emit) async {
    emit(WellnessHomeLoading());

    await Future.delayed(const Duration(milliseconds: 500));

    final hour = DateTime.now().hour;
    String greeting;
    String imagePath;

    if (hour >= 5 && hour < 12) {
      greeting = "Good Morning,\nTime to bloom.";
      imagePath = 'assets/images/wellness_morning.jpg';
    } else if (hour >= 12 && hour < 18) {
      greeting = "Good Afternoon,\nStay balanced.";
      imagePath = 'assets/images/wellness_day.jpg';
    } else {
      greeting = "Good Evening,\nUnwind and reflect.";
      imagePath = 'assets/images/wellness_evening.jpg';
    }

    emit(WellnessHomeLoaded(greeting: greeting, imageAssetPath: imagePath));
  }
}
