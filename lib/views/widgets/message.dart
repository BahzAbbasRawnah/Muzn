import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorSnackbar {
  static void show({
    required BuildContext context,
    required String errorText,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.amiri().fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating, // Make the SnackBar floating
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100, // Position at the top
          left: 20,
          right: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
    );
  }
}

class SuccessSnackbar {
  static void show({
    required BuildContext context,
    required String successText,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          successText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.amiri().fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating, // Make the SnackBar floating
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100, // Position at the top
          left: 20,
          right: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
    );
  }
}