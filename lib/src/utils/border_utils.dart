import 'package:flutter/material.dart';

/// Paints a luminous, multi-stop specular gradient stroke around a rounded
/// rectangle to reproduce Apple's Liquid Glass / visionOS rim reflection.
class LiquidSpecularBorderPainter extends CustomPainter {
  /// The border radius geometry.
  final BorderRadius borderRadius;

  /// The gradient used for the specular stroke.
  final Gradient gradient;

  /// The width of the specular stroke. Defaults to 1.0.
  final double strokeWidth;

  /// Creates a [LiquidSpecularBorderPainter].
  const LiquidSpecularBorderPainter({
    required this.borderRadius,
    required this.gradient,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (strokeWidth <= 0 || size.isEmpty) return;

    final rect = Offset.zero & size;
    final halfStroke = strokeWidth / 2.0;

    // Deflate the rect and the border radius so the stroke stays perfectly within bounds
    final innerRect = rect.deflate(halfStroke);
    final rrect = RRect.fromRectAndCorners(
      innerRect,
      topLeft: Radius.circular(
        (borderRadius.topLeft.x - halfStroke).clamp(0.0, double.infinity),
      ),
      topRight: Radius.circular(
        (borderRadius.topRight.x - halfStroke).clamp(0.0, double.infinity),
      ),
      bottomLeft: Radius.circular(
        (borderRadius.bottomLeft.x - halfStroke).clamp(0.0, double.infinity),
      ),
      bottomRight: Radius.circular(
        (borderRadius.bottomRight.x - halfStroke).clamp(0.0, double.infinity),
      ),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..shader = gradient.createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant LiquidSpecularBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.gradient != gradient ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
