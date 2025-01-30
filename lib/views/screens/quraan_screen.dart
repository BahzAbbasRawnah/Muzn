import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/screens/surah_details_screen.dart';
import 'package:quran/quran.dart' as quran;

class QuranScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "quran".tr(context),
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontFamily: GoogleFonts.amiriQuran().fontFamily,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: quran.totalSurahCount,
          itemBuilder: (context, index) {
            int surahNumber = index + 1;
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.black, // Border color
                  width: 0.5, // Border width
                ),
              )),
              child: GestureDetector(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        getSurahDetails(surahNumber,context), // Use the function here
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: GoogleFonts.amiriQuran().fontFamily,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      // child: Image.asset(
                      //   quran.getPlaceOfRevelation(surahNumber) == 'Makkah'
                      //       ? 'assets/images/makka.png'
                      //       : 'assets/images/madyna.png',
                      //       width: 10,
                      //       height: 30,
                      //       fit: BoxFit.fitWidth,
                      // )
                      flex: 1,
                      child: Text(
                        quran.getPlaceOfRevelation(surahNumber) == 'Makkah'
                            ? 'مكيّه'
                            : 'مدنيّه',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontFamily: GoogleFonts.amiriQuran().fontFamily,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {}, icon: Icon(Icons.audio_file)),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SurahDetailsScreen(surahNumber: surahNumber),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String getSurahDetails(int surahNumber,context) {
    String surahNameArabic = quran.getSurahNameArabic(surahNumber);
    int verseCount = quran.getVerseCount(surahNumber);
    String verseText = verseCount > 10 ? "verse".tr(context) : "verses".tr(context);
    return "$surahNameArabic ( $verseCount $verseText )";
  }
}
