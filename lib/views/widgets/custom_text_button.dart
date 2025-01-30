import 'package:flutter/material.dart';

// Custom TextButton widget
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
       
      ),
      child: Text(text),
    );
  }
}
