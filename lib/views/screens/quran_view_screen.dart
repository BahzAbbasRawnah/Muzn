import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muzn/app_localization.dart';
import 'package:quran/quran.dart' as quran;
import 'dart:async';

class QuranViewScreen extends StatefulWidget {
  final int surahNumber;

  const QuranViewScreen({Key? key, required this.surahNumber})
      : super(key: key);

  @override
  _QuranViewScreenState createState() => _QuranViewScreenState();
}

class _QuranViewScreenState extends State<QuranViewScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollSpeed = 0.0; // Scroll speed in pixels per second
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel(); // Cancel any existing timer
    _autoScrollTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_scrollSpeed > 0) {
        double newOffset = _scrollController.offset + (_scrollSpeed / 10);
        if (newOffset >= _scrollController.position.maxScrollExtent) {
          newOffset = 0; // Loop back to the top
        }
        _scrollController.jumpTo(newOffset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Combine all verses into a single string
    String allVerses = '';
    for (int i = 1; i <= quran.getVerseCount(widget.surahNumber); i++) {
      allVerses += quran.getVerse(widget.surahNumber, i, verseEndSymbol: true) + ' ';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('surah'.tr(context) + ' ' + quran.getSurahNameArabic(widget.surahNumber),
        ),
      ),
      body: Column(
        children: [
          Text(quran.basmala,style: GoogleFonts.amiriQuran(
            color: Colors.black,
            fontSize: 20,
            height: 2, 
            fontWeight: FontWeight.bold
          )),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(10),
              child: Text(
                allVerses,
                style: GoogleFonts.amiriQuran(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  wordSpacing: 0.2,
                  height: 2
                  
                ),
                
                textAlign: TextAlign.justify, // Justify text for better readability
              ),
            ),
          ),
          // Slider to control scroll speed
          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('scroll_speed'.tr(context),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Slider(
                      value: _scrollSpeed,
                      min: 0,
                      max: 100, // Adjust max speed as needed
                      onChanged: (value) {
                        setState(() {
                          _scrollSpeed = value;
                        });
                      },
                        activeColor: Theme.of(context).primaryColor,
                            inactiveColor: Theme.of(context).primaryColor.withAlpha(100),
                            thumbColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}