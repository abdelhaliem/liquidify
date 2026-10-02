import 'package:flutter/material.dart';

/// Color utility functions for Liquid Glass styling.
class LiquidColorUtils {
  LiquidColorUtils._();

  /// Safely alters alpha channel for a color.
  static Color withAlphaFactor(Color color, double factor) {
    final currentAlpha = color.a;
    final newAlpha = (currentAlpha * factor).clamp(0.0, 1.0);
    return color.withValues(alpha: newAlpha);
  }

  /// Blends two colors using a given [ratio] (0.0 to 1.0).
  static Color blend(Color a, Color b, double ratio) {
    return Color.lerp(a, b, ratio) ?? a;
  }
}
