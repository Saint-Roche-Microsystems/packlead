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
  static String formatDateUTC(DateTime date) {
    return _dateOnlyFormat.format(date);
  }

  /// example: 2026-02-10T23:59:59.000Z
  static String formatDateTimeUTC(DateTime date) {
    final utcDate = date.toUtc();
    return DateTime.utc(
      utcDate.year,
      utcDate.month,
      utcDate.day,
      23,
      59,
      59,
    ).toIso8601String();
  }

  // example: "Hace 5m", "Hace 2h", "Hace 3d"
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return 'Hace ${difference.inSeconds}s';
    if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes}m';
    if (difference.inHours < 24) return 'Hace ${difference.inHours}h';
    return 'Hace ${difference.inDays}d';
  }
}