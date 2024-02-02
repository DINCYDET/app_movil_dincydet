import 'package:intl/intl.dart';

final DateFormat timeFormat = DateFormat("HH:mm a");
final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

String isoDateTimeToTime(String isoDateTime) {
  final date = DateTime.parse(isoDateTime);
  final time = timeFormat.format(date);
  return time;
}

String isoDateTimeToTimeOrDay(String? isoDateTime) {
  if (isoDateTime == null) {
    return '';
  }
  final date = DateTime.parse(isoDateTime);
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inDays > 0) {
    return dateFormat.format(date);
  } else {
    return timeFormat.format(date);
  }
}
