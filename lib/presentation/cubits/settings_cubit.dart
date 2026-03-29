import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:affirmup/data/services/services.dart';

part 'settings_cubit.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isPremium,
    @Default(true) bool notificationsEnabled,
    @Default(false) bool quietHoursEnabled,
    @Default(22) int quietHoursStart,
    @Default(7) int quietHoursEnd,
  }) = _SettingsState;
}

class SettingsCubit extends Cubit<SettingsState> {
  final PremiumService _premiumService;
  final NotificationService _notificationService;

  SettingsCubit({
    required PremiumService premiumService,
    required NotificationService notificationService,
  })  : _premiumService = premiumService,
        _notificationService = notificationService,
        super(const SettingsState());

  void load() {
    emit(state.copyWith(
      isPremium: _premiumService.isPremium(),
      notificationsEnabled: _notificationService.isEnabled(),
      quietHoursEnabled: _notificationService.isQuietHoursEnabled(),
      quietHoursStart: _notificationService.getQuietHoursStart(),
      quietHoursEnd: _notificationService.getQuietHoursEnd(),
    ));
  }

  Future<void> toggleNotifications(bool value) async {
    await _notificationService.setEnabled(value);
    emit(state.copyWith(notificationsEnabled: value));
  }

  Future<void> toggleQuietHours(bool value) async {
    await _notificationService.setQuietHoursEnabled(value);
    emit(state.copyWith(quietHoursEnabled: value));
  }

  Future<void> setQuietHours(int start, int end) async {
    await _notificationService.setQuietHours(start, end);
    emit(state.copyWith(quietHoursStart: start, quietHoursEnd: end));
  }
}
