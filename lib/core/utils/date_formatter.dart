import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _ddMMyyyyFormat = DateFormat('dd/MM/yyyy');

  static final DateFormat _dateOnlyFormat = DateFormat('yyyy-MM-dd');

  static final DateFormat _fullFormat = DateFormat('dd/MM/yyyy HH:mm');

  /// example: 10/02/2026
  static String formatDate(DateTime date) {
    return _ddMMyyyyFormat.format(date);
  }

  /// example: 10/02/2026 14:30
  static String formatDateTime(DateTime date) {
    return _fullFormat.format(date);
  }

  /// example: 2026-02-10
  static String formatForBackend(DateTime date) {
    return _dateOnlyFormat.format(date);
  }
}