import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muzn/models/enums.dart';


class AppLocalization {
  final Locale? local;
  AppLocalization({this.local});

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();

  late Map<String, String> _localizedString;

  Future<void> loadJsonLanguage() async {
    if (local == null) {
      throw Exception("Locale is not set");
    }

    String jsonString = await rootBundle
        .loadString('assets/translations/${local!.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedString = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  String translate(String key) =>
      _localizedString[key] ??
      key; // Return the key itself if translation is not found
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(local: locale);
    await localization.loadJsonLanguage();
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}

extension Translate on String {
  String tr(BuildContext context) {
    return AppLocalization.of(context)!.translate(this);
  }
}

extension CircleTimeExtension on CircleTime {
  String toLocalizeTimedString(BuildContext context) {
    switch (this) {
      case CircleTime.morning:
        return 'morning'.tr(context);
      case CircleTime.noon:
        return 'noon'.tr(context);
      case CircleTime.afternoon:
        return 'afternoon'.tr(context);
      case CircleTime.maghrib:
        return 'maghrib'.tr(context);
      case CircleTime.evening:
        return 'evening'.tr(context);
      default:
     return 'morning'.tr(context);

    }
  }
}

extension CircleTypeExtension on CircleType {
  String toLocalizedTypeString(BuildContext context) {
    switch (this) {
      case CircleType.offline:
        return 'offline'.tr(context);
      case CircleType.online:
        return 'online'.tr(context);

      default:
        return 'offline'.tr(context);
    }
  }
}

extension RatingTranslation on Rating {
  String translate(BuildContext context) {
    switch (this) {
        case Rating.excellent:
        return "excellent".tr(context);
          case Rating.veryGood:
        return "very_good".tr(context);
      case Rating.good:
        return "good".tr(context);  
      case Rating.average:
        return "average".tr(context);
      case Rating.weak:
        return "weak".tr(context);
      default:
        return this.name; 
    }
  }
}

