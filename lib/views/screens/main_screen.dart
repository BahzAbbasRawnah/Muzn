import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muzn/app_localization.dart';

import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';
import 'package:muzn/views/widgets/screen_header.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  late Animation<int> _animation;

  final String titleText = 'مزن لتعليم القرآن الكريم';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  Future<void> _initializeDependencies() async {
    _startAnimation();
  }

  void _startAnimation() {
    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Duration for the first text
    );

    // Initialize animation
    _animation = IntTween(begin: 0, end: titleText.length).animate(_controller)
      ..addListener(() {
        setState(() {
          _currentIndex = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.forward(from: 0); // Restart animation for the second text
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
          title: 'home'.trans(context),
          scaffoldKey: _scaffoldKey,
        ),
        drawer: AppDrawer(), // Pass the userController here
        body: Column(children: [
          ScreenHeader(),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated first text
              Text(
                titleText.substring(
                    0, _currentIndex.clamp(0, titleText.length)),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: GoogleFonts.amiriQuran().fontFamily,
                ),
                textAlign: TextAlign.center, // Center-align the text
              ),
              SizedBox(height: deviceHeight * 0.03), // Spacing between texts

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
          ))
        ]));
  }
}
