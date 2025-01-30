import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;

class SurahDetailsScreen extends StatelessWidget {
  final int surahNumber;

  const SurahDetailsScreen({Key? key, required this.surahNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quran.getSurahNameArabic(surahNumber),
                       style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontFamily: GoogleFonts.amiriQuran().fontFamily,
                        fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView.builder(
        itemCount: quran.getVerseCount(surahNumber),
        itemBuilder: (context, index) {
          int verseNumber = index + 1;
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
              text: TextSpan(
                text: quran.getVerse(surahNumber, verseNumber, verseEndSymbol: true),
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: GoogleFonts.amiriQuran().fontFamily, 
                  fontWeight: FontWeight.w800
                ),
              ),
              softWrap: true, // Allows text to wrap to the next line
              overflow: TextOverflow.visible, // Handles overflow
            ),
          );
        },
      ),
    );
  }
}