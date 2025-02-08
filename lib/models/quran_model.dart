import 'package:quran/quran.dart' as quran;

class Surah {
  final int number;
  final String nameArabic;
  final int ayat_count;

  Surah(
      {required this.number,
      required this.nameArabic,
      required this.ayat_count});
}

class QuranService {
  static List<Surah> getAllSurahs() {
    return List.generate(114, (index) {
      int surahNumber = index + 1;
      return Surah(
          number: surahNumber,
          nameArabic: quran.getSurahNameArabic(surahNumber),
          ayat_count: quran.getVerseCount(surahNumber));
    });
  }
}
