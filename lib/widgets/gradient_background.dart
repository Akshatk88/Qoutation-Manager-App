import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF00B4DB),  // top blue-teal
            Color(0xFF0083B0),  // middle teal
            Color(0xFFE6F7FA),  // soft light bottom
          ],
        ),
      ),
      child: child,
    );
  }
}
