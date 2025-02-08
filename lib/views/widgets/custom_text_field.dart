import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int line;
  final bool? readonly;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function()? onSuffixTap;
  final Function()? onPrefixTap;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.line = 1,
    this.readonly,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.onSuffixTap,
    this.onPrefixTap,
    this.validator, // Added validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Changed from TextField to TextFormField
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLines: line,
      validator: validator, // Set the validator here
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.labelMedium,
        hintText: hintText,
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffda9f35), width: 1.0),
        ),
        border: OutlineInputBorder(),
        prefixIcon: prefixIcon != null
            ? GestureDetector(
                onTap: onPrefixTap,
                child: Icon(
                  prefixIcon,
                  color: Theme.of(context)
                      .primaryColor, // Get icon color from primary color of the theme
                ),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIcon,
                  color: Theme.of(context)
                      .primaryColor, // Get icon color from primary color of the theme
                ),
              )
            : null,
      ),
    );
  }
}
