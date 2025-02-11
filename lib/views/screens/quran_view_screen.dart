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
  int _currentPageNumber = 1;
  int _currentJuzNumber = 1;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    int currentVerse = (_scrollController.offset / 100).floor() + 1;
    int pageNumber = quran.getPageNumber(widget.surahNumber, currentVerse);
    int juzNumber = quran.getJuzNumber(widget.surahNumber, currentVerse);

    if (_currentPageNumber != pageNumber || _currentJuzNumber != juzNumber) {
      setState(() {
        _currentPageNumber = pageNumber;
        _currentJuzNumber = juzNumber;
      });
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_scrollSpeed > 0) {
        double newOffset = _scrollController.offset + (_scrollSpeed / 10);
        if (newOffset >= _scrollController.position.maxScrollExtent) {
          newOffset = 0; // Reset scroll position
        }
        _scrollController.jumpTo(newOffset);
      }
    });
  }

  String getJuzName(int juzNumber) => 'juz_$juzNumber'.tr(context);

  String getHezbName(int pageNumber) {
    int hezbNumber = (pageNumber) ~/ 10 + 1;
    return 'hezb_$hezbNumber'.tr(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> verses = List.generate(
      quran.getVerseCount(widget.surahNumber),
      (i) => quran.getVerse(widget.surahNumber, i + 1, verseEndSymbol: true),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('surah'.tr(context) +
            ' ' +
            quran.getSurahNameArabic(widget.surahNumber),
           
            ),
      ),
      body: Column(
        children: [
          _buildHeader(context),
          _buildQuranContent(verses),
          _buildScrollSpeedControl(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
           border: Border.all(
            color: Theme.of(context).primaryColor.withAlpha(80),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withAlpha(100),

      ),
      margin: EdgeInsets.all(2),
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildText(getJuzName(_currentJuzNumber)),
          _buildText('{ $_currentPageNumber }'),
          _buildText(getHezbName(_currentPageNumber)),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: GoogleFonts.amiri(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 18,
        height: 2,
        
      ),
      overflow: TextOverflow.fade,
    );
  }

  Widget _buildQuranContent(List<String> verses) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withAlpha(20),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text(
            verses.join(' '),
            style: GoogleFonts.amiri(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 25,
              wordSpacing: 0.2,
              letterSpacing: 0.3,
              height: 2,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }

  Widget _buildScrollSpeedControl() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 5),
      child: Row(
        children: [
          Text(
            'scroll_speed'.tr(context),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Slider(
              value: _scrollSpeed,
              min: 0,
              max: 100,
              onChanged: (value) => setState(() => _scrollSpeed = value),
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Theme.of(context).primaryColor.withAlpha(100),
              thumbColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
