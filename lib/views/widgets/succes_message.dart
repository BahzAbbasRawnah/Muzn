 // custom_snackbar.dart
import 'package:flutter/material.dart';

class CustomSnackBar {
  /// Show a success SnackBar with a checkmark icon and green background.
  static void showSuccess(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white), // Success icon
            SizedBox(width: 10), // Spacing between icon and text
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: duration,
        backgroundColor: Colors.green, // Success background color
        behavior: SnackBarBehavior.floating, // Floating SnackBar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
    );
  }

  /// Show a failed SnackBar with an error icon and red background.
  static void showFailed(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white), // Error icon
            SizedBox(width: 10), // Spacing between icon and text
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: duration,
        backgroundColor: Colors.red, // Error background color
        behavior: SnackBarBehavior.floating, // Floating SnackBar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
    );
  }
}