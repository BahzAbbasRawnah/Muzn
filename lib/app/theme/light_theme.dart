import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xffda9f35),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: const Color(0xffda9f35),
    titleTextStyle: GoogleFonts.amiri(
      textStyle: const TextStyle(
        color: Color(0xff1f1f1f),
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      
    ),
    iconTheme: const IconThemeData(
      color: Color(0xff1f1f1f),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffda9f35),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      iconColor: Colors.white,
      iconSize: 25,
      textStyle: GoogleFonts.amiri(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xffda9f35),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 2.0,
    iconSize: 20,
  ),


  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(5),
      foregroundColor: const Color(0xffda9f35),
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
    ),
    labelStyle: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xff1f1f1f),
      ),
    ),
    hintStyle: GoogleFonts.amiri(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: const Color.fromARGB(176, 27, 27, 27).withAlpha(2),
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
        color: Color(0xff1f1f1f),
      ),
    ),
    displayMedium: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 21, 20, 20),
      ),
    ),
    displaySmall: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Color(0xff1f1f1f),
      ),
    ),
    titleLarge: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Color(0xffda9f35),
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
        color: Color(0xff1f1f1f),
      )
      ),
      labelMedium: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff1f1f1f),
      )
      ),
      labelSmall: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff1f1f1f),
      )
      )
  ),
  iconTheme: const IconThemeData(
    color: Color(0xffda9f35),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: const Color(0xffda9f35),
    titleTextStyle: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xff1f1f1f),
      ),
    ),
    subtitleTextStyle: GoogleFonts.amiri(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Color(0xff1f1f1f),
      ),
    ),
  ),
  cardTheme: const CardTheme(color: Colors.white),

);
