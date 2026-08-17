import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiss_ai/presentation/shared/adaptive_theme/adaptive_theme_state.dart';

class AdaptiveThemeCubit extends Cubit<AdaptiveThemeState> {
  AdaptiveThemeCubit() : super(AdaptiveThemeState.dark);

  void setLightTheme() {
    emit(AdaptiveThemeState.light);
  }

  void setDarkTheme() {
    emit(AdaptiveThemeState.dark);
  }
}
