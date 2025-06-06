import 'package:flutter/material.dart';

void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green, // Customize the color
      behavior: SnackBarBehavior.floating, // Optional: Make it floating
    ),
  );
}
