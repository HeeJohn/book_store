import 'dart:math';
import 'package:flutter/material.dart';

class RandomColor extends StatelessWidget {
  const RandomColor({super.key});

  Color _generateRandomColor() {
    final random = Random();
    final r = random.nextInt(101) + 100; // Red between 100 and 200
    final g = random.nextInt(101) + 100; // Green between 100 and 200
    final b = random.nextInt(101) + 100; // Blue between 100 and 200
    return Color.fromRGBO(r, g, b, 1.0);
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate the relative luminance (per ITU-R BT.709)
    double luminance = (0.2126 * backgroundColor.red +
            0.7152 * backgroundColor.green +
            0.0722 * backgroundColor.blue) /
        255;

    // Decide the text color based on the background luminance
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
