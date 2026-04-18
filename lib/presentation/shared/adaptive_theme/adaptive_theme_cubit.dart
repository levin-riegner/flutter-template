import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:color_picker/presentation/shared/adaptive_theme/adaptive_theme_state.dart';

class AdaptiveThemeCubit extends Cubit<AdaptiveThemeState> {
  AdaptiveThemeCubit() : super(AdaptiveThemeState.dark);

  void setLightTheme() {
    emit(AdaptiveThemeState.light);
  }

  void setDarkTheme() {
    emit(AdaptiveThemeState.dark);
  }
}
