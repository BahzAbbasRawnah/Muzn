import 'package:flutter/material.dart';
import 'dart:math';

class LeafContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: LeafClipper(),
      child: Container(
        height: 150,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.amber,
        ),
      ),
    );
  }
}

class LeafClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0); // Start at the top center
    path.quadraticBezierTo(
        size.width, size.height / 3, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height / 2);
    path.quadraticBezierTo(0, size.height / 3, size.width / 2, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
