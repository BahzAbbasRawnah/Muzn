import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:quran/quran.dart' as quran;
import 'dart:async';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QuranPdfScreen extends StatefulWidget {
  final int surahNumber;

  const QuranPdfScreen({Key? key, this.surahNumber = 1}) : super(key: key);

  @override
  _QuranPdfScreenState createState() => _QuranPdfScreenState();
}

class _QuranPdfScreenState extends State<QuranPdfScreen> {
  final PdfViewerController _pdfController = PdfViewerController();
  double _scrollSpeed = 0.0; // Default scroll speed in pixels per second
  Timer? _autoScrollTimer;
  double _currentPosition = 0; // Keeps track of the scroll position

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel(); // Cancel any existing timer

    _autoScrollTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_scrollSpeed > 0) {
        double newOffset = _currentPosition + (_scrollSpeed / 10); // Move gradually

        // Prevent exceeding max scroll limit
        if (newOffset >= _pdfController.pageCount * 100) {
          newOffset = 0; // Restart from the top if end is reached
        }

        _pdfController.jumpTo(yOffset: newOffset);
        _currentPosition = newOffset;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'surah'.trans(context) + ' ' + quran.getSurahNameArabic(widget.surahNumber),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.asset(
              'assets/static/quran.pdf',
              controller: _pdfController, // Correct controller usage
            ),
          ),
          // Slider to control scroll speed
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  'scroll_speed'.trans(context),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Slider(
                    value: _scrollSpeed,
                    min: 0,
                    max: 100, // Adjust max speed as needed
                    onChanged: (value) {
                      setState(() {
                        _scrollSpeed = value;
                        _startAutoScroll(); // Restart scrolling with new speed
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
        ],
      ),
    );
  }
}
