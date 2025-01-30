import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xffda9f35),
  scaffoldBackgroundColor: const Color(0xff121212), // Dark background
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: const Color(0xff1f1f1f), // Darker app bar
    titleTextStyle: GoogleFonts.amiri(
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white, // Light icons for contrast
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffda9f35),
      foregroundColor: Colors.black, // Text color on buttons
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      iconColor: Colors.black,
      iconSize: 25,
      textStyle: GoogleFonts.amiri(
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xffda9f35),
    foregroundColor: Colors.black, // Light text/icon
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 2.0,
    iconSize: 20,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(5),
      foregroundColor: const Color(0xffda9f35), // Highlight color
      textStyle: GoogleFonts.amiri(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffda9f35)),
    ),
    labelStyle: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    hintStyle: GoogleFonts.amiri(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white.withOpacity(0.6),
      ),
    ),
    errorStyle: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    ),
    alignLabelWithHint: true,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    displayMedium: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    ),
    displaySmall: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
    ),
    titleLarge: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Color(0xffda9f35), // Highlighted color
      ),
    ),
    titleMedium: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Color(0xffda9f35),
      ),
    ),
    titleSmall: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        color: Color(0xffda9f35),
      ),
    ),
    labelLarge: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    ),
    labelMedium: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    labelSmall: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  listTileTheme: ListTileThemeData(
    iconColor: const Color(0xffda9f35),
    titleTextStyle: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    subtitleTextStyle: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
    ),
  ),
  cardTheme: const CardTheme(
    color: Color(0xff1f1f1f), // Dark card background
  ),
);
