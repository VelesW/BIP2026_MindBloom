import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/local_storage_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalStorageService _localStorageService;

  ThemeBloc(this._localStorageService)
      : super(ThemeUpdated(_localStorageService.isDarkMode)) {

    on<ToggleTheme>((event, emit) async {
      await _localStorageService.saveThemeMode(event.isDarkMode);

      emit(ThemeUpdated(event.isDarkMode));
    });
  }
}
