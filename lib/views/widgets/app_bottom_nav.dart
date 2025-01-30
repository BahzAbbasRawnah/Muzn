// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class BottomNavigation extends StatefulWidget {
//   const BottomNavigation({Key? key}) : super(key: key);

//   @override
//   _BottomNavigationState createState() => _BottomNavigationState();
// }

// class _BottomNavigationState extends State<BottomNavigation> {
//   int _selectedIndex = 0;
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ConvexAppBar(
//       backgroundColor: Colors.white,
//       style: TabStyle.reactCircle,
//       activeColor: Theme.of(context).primaryColor,
//       color: const Color(0xff1f1f1f),
//       items: [
//         TabItem(
//             icon: Icons.group,
//             title: 'community'.tr(),
//             fontFamily: GoogleFonts.amiri().fontFamily),
//         TabItem(
//             icon: Icons.mosque,
//             title: 'school'.tr(),
//             fontFamily: GoogleFonts.amiri().fontFamily),
//         TabItem(
//             icon: Icons.group,
//             title: 'circle'.tr(),
//             fontFamily: GoogleFonts.amiri().fontFamily),
//         TabItem(
//             icon: Icons.query_stats_sharp,
//             title: 'calculate'.tr(),
//             fontFamily: GoogleFonts.amiri().fontFamily),
//         TabItem(
//             icon: Icons.person,
//             title: 'profile'.tr(),
//             fontFamily: GoogleFonts.amiri().fontFamily),
//       ],
//       onTap: _onItemTapped, // Update the selected index
//     );
//   }
// }
