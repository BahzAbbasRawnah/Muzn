import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/screens/quran_audio_screen.dart';
import 'package:muzn/views/screens/quran_view_screen.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:quran/quran.dart' as quran;

class QuranScreen extends StatefulWidget {
  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<int> _filteredSurahNumbers =
      List.generate(quran.totalSurahCount, (index) => index + 1);

  // Reusable text style
  final TextStyle _surahTextStyle = TextStyle(
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: GoogleFonts.amiri().fontFamily,
    fontWeight: FontWeight.w800,
  );

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSurahs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSurahs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSurahNumbers =
          List.generate(quran.totalSurahCount, (index) => index + 1)
              .where((surahNumber) {
        final surahName = quran.getSurahNameArabic(surahNumber).toLowerCase();
        return surahName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("quran".tr(context)),
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3,vertical: 5),
            child: CustomTextField(
              controller: _searchController,
              hintText: 'surah_search'.tr(context),
              prefixIcon: Icons.search,
            ),
          ),

          // Surah List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 5),
              child: ListView.builder(
                itemCount: _filteredSurahNumbers.length,
                itemBuilder: (context, index) {
                  int surahNumber = _filteredSurahNumbers[index];
                  return Card(
                    elevation: 4,
                    child: GestureDetector(
                      
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              getSurahDetails(surahNumber, context),
                              style: _surahTextStyle, // Use reusable text style
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              quran.getPlaceOfRevelation(surahNumber) == 'Makkah'
                                  ? 'مكيّه'
                                  : 'مدنيّه',
                              style: _surahTextStyle, // Use reusable text style
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AudioPlayerScreen(
                                      surahNumber: surahNumber,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.audio_file),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuranViewScreen(
                              surahNumber: surahNumber,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getSurahDetails(int surahNumber, context) {
    String surahNameArabic = quran.getSurahNameArabic(surahNumber);
    int verseCount = quran.getVerseCount(surahNumber);
    String verseText =
        verseCount > 10 ? "verse".tr(context) : "verses".tr(context);
    return "$surahNameArabic ( $verseCount $verseText )";
  }
}
