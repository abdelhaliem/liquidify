import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/liquid_glass_options.dart';

/// A widget that renders using native iOS `UIGlassEffectView` on iOS,
/// embedding the real Apple Liquid Glass material via Platform Views.
///
/// On non-iOS platforms or when the native view is unavailable, this
/// widget returns [fallback] or an empty [SizedBox].
///
/// ```dart
/// NativeLiquidGlassView(
///   options: LiquidGlassOptions(blur: 20),
///   width: 300,
///   height: 200,
///   child: Text('Hello Glass'),
///   fallback: MyFlutterGlassWidget(),
/// )
/// ```
class NativeLiquidGlassView extends StatelessWidget {
  /// The child widget rendered on top of the glass surface.
  final Widget? child;

  /// Optional Liquid Glass configuration.
  final LiquidGlassOptions? options;

  /// Width of the native view.
  final double? width;

  /// Height of the native view.
  final double? height;

  /// Corner radius for the glass container.
  final double cornerRadius;

  /// Widget to display when native glass is not available.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassView].
  const NativeLiquidGlassView({
    super.key,
    this.child,
    this.options,
    this.width,
    this.height,
    this.cornerRadius = 20.0,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    // Only use native view on iOS
    if (!_isIOSPlatform) {
      return fallback ?? const SizedBox.shrink();
    }

    final creationParams = _buildCreationParams(context);

    // UiKitView requires bounded constraints. If no explicit size
    // is provided, return the fallback widget.
    if (width == null || height == null) {
      return fallback ?? const SizedBox.shrink();
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          UiKitView(
            viewType: 'liquidify/glass_container',
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            gestureRecognizers: const {},
          ),
          if (child != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(cornerRadius),
              child: child!,
            ),
        ],
      ),
    );
  }

  Map<String, dynamic> _buildCreationParams(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tintColor = options?.tint;
    int? tintColorValue;
    if (tintColor != null) {
      tintColorValue =
          ((tintColor.a * 255).toInt() << 24) |
          ((tintColor.r * 255).toInt() << 16) |
          ((tintColor.g * 255).toInt() << 8) |
          (tintColor.b * 255).toInt();
    }

    return {
      'cornerRadius': cornerRadius,
      'style': isDark ? 'dark' : 'regular',
      'tintColor': tintColorValue,
      'blur': options?.blur,
      'showBorder': (options?.borderWidth ?? 1.0) > 0,
      'borderWidth': options?.borderWidth ?? 0.5,
    };
  }

  static bool get _isIOSPlatform {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }
}
