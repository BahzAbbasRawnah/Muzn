import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  late Animation<int> _animation;

  final String _firstText = 'ليدبروا آياته';
  final String _secondText = 'مزن القرآن ';
  int _currentIndex = 0;
  bool _isFirstTextCompleted = false;
  int _repeatCount = 0; // Track the number of repetitions

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Duration for the first text
    );

    // Initialize animation
    _animation = IntTween(begin: 0, end: _firstText.length).animate(_controller)
      ..addListener(() {
        setState(() {
          _currentIndex = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (!_isFirstTextCompleted) {
            // First text animation completed
            _isFirstTextCompleted = true;
            _controller.duration = const Duration(seconds: 4); // Duration for the second text
            _controller.forward(from: 0); // Restart animation for the second text
          } else {
            // Second text animation completed
            _repeatCount++; // Increment repetition count
            if (_repeatCount < 1) {
              // Repeat only twice
              Future.delayed(const Duration(seconds: 2), () {
                _isFirstTextCompleted = false;
                _controller.duration = const Duration(seconds: 5); // Reset duration for the first text
                _controller.forward(from: 0); // Restart animation for the first text
              });
            } else {
              // Stop the animation after 2 repetitions
              _controller.stop();
            }
          }
        }
      });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'home'.tr(context),
        scaffoldKey: _scaffoldKey,
      ),
      drawer:  AppDrawer(),
      body: SingleChildScrollView(
        // Make the screen scrollable
        child: SizedBox(
          height: deviceHeight, // Set height to the device height
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated first text
              Text(
                _firstText.substring(
                    0, _isFirstTextCompleted ? _firstText.length : _currentIndex.clamp(0, _firstText.length)),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: GoogleFonts.amiriQuran().fontFamily,
                ),
                textAlign: TextAlign.center, // Center-align the text
              ),
              SizedBox(height: deviceHeight * 0.03), // Spacing between texts
              // Animated second text
              Text(
                _secondText.substring(
                    0, _isFirstTextCompleted ? _currentIndex.clamp(0, _secondText.length) : 0),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: GoogleFonts.amiriQuran().fontFamily,
                ),
                textAlign: TextAlign.center, // Center-align the text
              ),
              SizedBox(height: deviceHeight * 0.03), // Spacing between text and GIF
              // Gif
              Center(
                child: GifView.asset(
                  'assets/images/quran.gif',
                  height: deviceHeight * 0.40, // Adjusted height
                  width: deviceWidth * 0.80, // Adjusted width
                  frameRate: 30,
                  fit: BoxFit.contain, // Use BoxFit.contain to avoid overflow
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}