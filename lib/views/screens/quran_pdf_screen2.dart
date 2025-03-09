import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:quran/quran.dart' as quran;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QuranPdfScreen2 extends StatefulWidget {
  final int surahNumber;

  const QuranPdfScreen2({super.key, this.surahNumber = 1});

  @override
  _QuranPdfScreenState createState() => _QuranPdfScreenState();
}

class _QuranPdfScreenState extends State<QuranPdfScreen2> {
  final PdfViewerController _pdfController = PdfViewerController();
  List<int> pageNumpers=[];
  double _scrollSpeed = 0.0; // Default scroll speed in pixels per second
  Timer? _autoScrollTimer;
  double _currentPosition = 0; // Keeps track of the scroll position

  @override
  void initState() {
     pageNumpers=quran.getSurahPages(widget.surahNumber);
     _pdfController.jumpToPage(pageNumpers.first);

     print('pageNumpers.toString()');
     print(pageNumpers.toString());
     print(quran.totalPagesCount);
     print(_pdfController.pageCount);
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    print('_pdfController.pageCount');
    print(_pdfController.pageCount);
    _autoScrollTimer?.cancel(); // Cancel any existing timer

    _autoScrollTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_scrollSpeed > 0) {
        double newOffset = _currentPosition + (_scrollSpeed / 10); // Move gradually
// _pdfController.
        // Prevent exceeding max scroll limit

        if (newOffset >= _pdfController.pageCount * 100) {
          newOffset = 0; // Restart from the top if end is reached
        }
// _pdfController.jumpToPage(pageNumber)
        _pdfController.jumpTo(yOffset: newOffset);
        _currentPosition = newOffset;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('quran pdf screen');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${'surah'.trans(context)} ${quran.getSurahNameArabic(widget.surahNumber)}',
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