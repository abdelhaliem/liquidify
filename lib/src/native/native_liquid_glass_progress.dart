import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS `UIProgressView` with Liquid Glass track.
///
/// On iOS 26+, uses `UIGlassEffect` behind the progress track for
/// the authentic Apple glass look. Supports animated progress updates.
class NativeLiquidGlassProgress extends StatefulWidget {
  /// Current progress value (0.0 to 1.0).
  final double progress;

  /// Corner radius of the glass container.
  final double cornerRadius;

  /// Height of the progress track.
  final double trackHeight;

  /// Tint color for the progress fill.
  final Color? tintColor;

  /// Tint color for the track background.
  final Color? trackTintColor;

  /// Height of the entire view.
  final double height;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassProgress].
  const NativeLiquidGlassProgress({
    super.key,
    this.progress = 0.0,
    this.cornerRadius = 8.0,
    this.trackHeight = 6.0,
    this.tintColor,
    this.trackTintColor,
    this.height = 36.0,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassProgress> createState() =>
      _NativeLiquidGlassProgressState();
}

class _NativeLiquidGlassProgressState
    extends State<NativeLiquidGlassProgress> {
  MethodChannel? _channel;

  @override
  void didUpdateWidget(NativeLiquidGlassProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _channel?.invokeMethod('setProgress', {
        'progress': widget.progress,
        'animated': true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/progress',
        creationParams: {
          'progress': widget.progress,
          'cornerRadius': widget.cornerRadius,
          'trackHeight': widget.trackHeight,
          'tintColor': _colorToInt(widget.tintColor),
          'trackTintColor': _colorToInt(widget.trackTintColor),
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/progress_$viewId');
  }

  static int? _colorToInt(Color? color) {
    if (color == null) return null;
    return ((color.a * 255).toInt() << 24) |
        ((color.r * 255).toInt() << 16) |
        ((color.g * 255).toInt() << 8) |
        (color.b * 255).toInt();
  }
}
