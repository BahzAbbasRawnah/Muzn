import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/screens/calculate_screen.dart';
import 'package:muzn/views/screens/circles_list_screen.dart';
import 'package:muzn/views/screens/main_screen.dart';
import 'package:muzn/views/screens/profile_screen.dart';
import 'package:muzn/views/screens/schools_list_screen.dart';
import 'package:muzn/views/widgets/app_drawer.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';
import 'package:muzn/views/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of pages for the different bottom navigation bar items
  final List<Widget> _pages = [
    SchoolsListScreen(),
    CirclesListScreen(),
    const MainScreen(),
     CalculateScreen(),
    const ProfileScreen(),
  ];

  // List of titles for each screen
  final List<String> _titles = [
    'schools',
    'circles',
    'home',
    'calculate',
    'profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _pages[_selectedIndex], // Page content based on selected tab
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.white,
        style: TabStyle.reactCircle,
        activeColor: Theme.of(context).primaryColor,
        color: const Color(0xff1f1f1f),
        initialActiveIndex: _selectedIndex,
        items: [
          TabItem(
            icon: Icons.mosque_outlined,
            title: 'schools'.tr(context),
            fontFamily: GoogleFonts.amiri().fontFamily,
          ),
          TabItem(
            icon: Icons.group_outlined,
            title: 'circles'.tr(context),
            fontFamily: GoogleFonts.amiri().fontFamily,
          ),
          TabItem(
            icon: Icons.home_outlined,
            title: 'home'.tr(context),
            fontFamily: GoogleFonts.amiri().fontFamily,
          ),
          TabItem(
            icon: Icons.query_stats_sharp,
            title: 'calculate'.tr(context),
            fontFamily: GoogleFonts.amiri().fontFamily,
          ),
          TabItem(
            icon: Icons.person_outline,
            title: 'profile'.tr(context),
            fontFamily: GoogleFonts.amiri().fontFamily,
          ),
        ],
        onTap: _onItemTapped, // Update the selected index
      ),
    );
  }
}