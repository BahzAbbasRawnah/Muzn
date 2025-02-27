// constants.dart
import 'package:flutter/widgets.dart';
import 'package:jhijri/_src/_jHijri.dart';

double getDeviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getDeviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

class DateTimeHelper {
  static String getCurrentMiladyDate() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  static String getCurrentHijriDate() {
    final hijriDate = JHijri.now();
    return "${hijriDate.year}-${hijriDate.month}-${hijriDate.day}";
  }
}
