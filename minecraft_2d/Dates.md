# Dates



```dart
// final now = DateTime.now();

// final monthFirstDay = DateTime(now.year, now.month, 1);
// final monthLastDay = DateTime(now.year, now.month + 1, 0);

// final weekFirstDay = now.subtract(Duration(days: now.weekday - 1));
// final weekLastDay = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));

// final LastWeekDay = now.subtract(const Duration(days: 7));
// final todayDay = now;

import 'package:intl/intl.dart';

final DateFormat formater_ddMMyyyyhhmm = DateFormat('dd/MM/yyyy hh:mm');
final DateFormat formater_ddMMyyyy = DateFormat('dd/MM/yyyy');
final DateFormat formater_HHmm = DateFormat('hh:mm');
final DateFormat formater_EEE = DateFormat('EEE', 'pt-BR');
final DateFormat formater_EEEE = DateFormat('EEEE', 'pt-BR');
NumberFormat numberFormat = NumberFormat.decimalPattern('pt-BR');
final NumberFormat BLRFormater =
    NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

String secondsToMinSecs(int seconds) {
  int minutes = (seconds / 60).truncate();
  String minutesStr = (minutes % 60).toString().padLeft(2, '0');
  String secondsStr = seconds == 60
      ? 0.toString().padLeft(2, '0')
      : seconds.toString().padLeft(2, '0');

  return '$minutesStr:$secondsStr';
}

String getOnlyMinutesFromSecs(int seconds) {
  return (seconds / 60).truncate().toString();
}

String getOnlyHoursFromMinutes(int minutes) {
  return (minutes / 60).truncate().toString();
}

String secondsToHourAndMinutes(int seconds) {
  int hours = (seconds / 3600).truncate();
  int minutes = (seconds % 3600 / 60).truncate();
  String hoursText = hours.toString().padLeft(2, '0');
  String minutesText = minutes.toString().padLeft(2, '0');
  return '$hoursText:$minutesText';
}

int hourAndMinutesToSeconds(String hhmm) {
  List<String> splitedHHmm = hhmm.split(':');
  int hours = int.parse(splitedHHmm[0]) * 3600;
  int minutes = (int.parse(splitedHHmm[1]) * 3600 / 60).truncate();
  int result = hours + minutes;
  return result;
}

String minutuesToHourAndMinutes(int minutes) {
  int hours = (minutes / 60).truncate();
  int mins = (minutes % 60).truncate();
  String hoursText = hours.toString().padLeft(2, '0');
  String minutesText = mins.toString().padLeft(2, '0');
  return '$hoursText:$minutesText';
}

DateTime ddMMyyyyhhmmToDate(String stringDate) {
  List<String> splitedDate = stringDate.split('/');
  return DateTime(int.parse(splitedDate[2]), int.parse(splitedDate[1]),
      int.parse(splitedDate[0]));
}
```
