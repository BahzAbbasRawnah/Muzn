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

  String translate(String key) {
    if (_localizedString == null || !_localizedString.containsKey(key)) {
      return key; // Return the key itself if translation is not found
    }
    return _localizedString[key]!;
  }
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
  String trans(BuildContext context) {
    return AppLocalization.of(context)!.translate(this);
  }
}

extension CircleTimeExtension on CircleTime {
  String toLocalizeTimedString(BuildContext context) {
    switch (this) {
      case CircleTime.morning:
        return 'morning'.trans(context);
      case CircleTime.noon:
        return 'noon'.trans(context);
      case CircleTime.afternoon:
        return 'afternoon'.trans(context);
      case CircleTime.maghrib:
        return 'maghrib'.trans(context);
      case CircleTime.evening:
        return 'evening'.trans(context);
      default:
        return 'morning'.trans(context);
    }
  }
}

extension CircleTypeExtension on CircleType {
  String toLocalizedTypeString(BuildContext context) {
    switch (this) {
      case CircleType.offline:
        return 'offline'.trans(context);
      case CircleType.online:
        return 'online'.trans(context);

      default:
        return 'offline'.trans(context);
    }
  }
}

extension RatingTranslation on Rating {
  String translate(BuildContext context) {
    switch (this) {
      case Rating.excellent:
        return "excellent".trans(context);
      case Rating.very_good:
        return "very_good".trans(context);
      case Rating.good:
        return "good".trans(context);
      case Rating.average:
        return "average".trans(context);
      case Rating.weak:
        return "weak".trans(context);
      default:
        return this.name;
    }
  }
}
