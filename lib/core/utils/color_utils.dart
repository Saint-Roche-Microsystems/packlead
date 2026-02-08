import 'dart:math';
import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();

  static final List<Color> markerColors = [
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
  ];

  static Color getRandomColor() {
    final random = Random();
    return markerColors[random.nextInt(markerColors.length)];
  }
}