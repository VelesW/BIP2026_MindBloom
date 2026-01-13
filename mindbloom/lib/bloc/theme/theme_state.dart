import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}

class ThemeUpdated extends ThemeState {
  const ThemeUpdated(super.isDarkMode);
}
