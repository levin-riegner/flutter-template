import 'package:flutter_bloc/flutter_bloc.dart';

class LocalValidableCubit extends Cubit<bool> {
  LocalValidableCubit() : super(false);

  void setCanSubmit(bool canSubmit) {
    emit(canSubmit);
  }
}
