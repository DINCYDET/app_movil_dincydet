import 'package:intl/intl.dart';

String gmtToLocalDateTime(String date) {
  try {
    final formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
    final dt = formatter.parse(date).toLocal();
    final localDate = DateFormat('dd/MM/yyyy, hh:mm a').format(dt);
    return localDate;
  } catch (e) {
    return "Formato de fecha incorrecto";
  }
}

String gmtToLocalDate(String date) {
  final formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
  final dt = formatter.parse(date, true).toLocal();
  final localDate = DateFormat('dd-MM-yyyy').format(dt);
  return localDate;
}

String gmtToUSDate(String date) {
  final formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
  final dt = formatter.parse(date, true).toLocal();
  final localDate = DateFormat('yyyy-MM-dd').format(dt);
  return localDate;
}

String isoToLocalDate(String? date) {
  // Parse iso date
  if (date == null) return 'Formato de fecha incorrecto';
  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final dt = formatter.parse(date, true); //.toLocal();
  final localDate = DateFormat('dd/MM/yyyy').format(dt);
  return localDate;
}

DateTime? isoParseDateTime(String date) {
  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final dt = formatter.parse(date, true); //.toLocal();
  return dt;
}

String isoToLocalTime(String? date) {
  // Parse iso date
  if (date == null) return 'Formato de fecha incorrecto';
  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final dt = formatter.parse(date, true); //.toLocal();
  final localDate = DateFormat('HH:mm:ss').format(dt);
  return '$localDate h';
}

String isoToLocalDateTime(String date) {
  // Parse iso date
  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final dt = formatter.parse(date, true); //.toLocal();
  final localDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(dt);
  return localDate;
}

double isoToNumericDate(String data) {
  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final dt = formatter.parse(data, true); //.toLocal();
  return dt.hour.toDouble() + (dt.minute.toDouble() / 60);
}
