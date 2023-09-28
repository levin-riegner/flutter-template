import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/presentation/shared/adaptive_theme/adaptive_theme_state.dart';

class AdaptiveThemeCubit extends Cubit<AdaptiveThemeState> {
  AdaptiveThemeCubit() : super(AdaptiveThemeState.dark);

  setLightTheme() {
    emit(AdaptiveThemeState.light);
  }

  setDarkTheme() {
    emit(AdaptiveThemeState.dark);
  }
}
