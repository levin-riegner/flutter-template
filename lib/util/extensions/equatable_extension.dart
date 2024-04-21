import 'package:equatable/equatable.dart';
import 'package:flutter_template/util/extensions/string_extension.dart';

extension SubmittableStateExtension on Equatable {
  bool get canSubmit => props.every(
        (element) {
          // TODO: Add more conditions as needed

          if (element is String) {
            return !element.isNullOrEmpty;
          } else if (element is bool) {
            return element;
          } else {
            return false;
          }
        },
      );
}
