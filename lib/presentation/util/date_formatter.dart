import 'package:intl/intl.dart';

abstract class DateFormatter {

  static String yMMMMd(DateTime dateTime) {
    DateFormat formatter = DateFormat.yMMMMd();
    final formatted = formatter.format(dateTime);
    return formatted;
  }

  static String yMd(DateTime dateTime) {
    DateFormat formatter = DateFormat.yMd();
    final formatted = formatter.format(dateTime);
    return formatted;
  }
}