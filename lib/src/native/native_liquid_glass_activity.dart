import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Size style for [NativeLiquidGlassActivity].
enum LiquidActivityStyle {
  /// Compact spinner.
  medium,

  /// Larger spinner.
  large,
}

/// A native iOS `UIActivityIndicatorView` in a Liquid Glass capsule.
///
/// On iOS 26+, the capsule uses `UIGlassEffect` for the authentic
/// Apple glass spinner look. Supports an optional text label and
/// start/stop control via method channel.
class NativeLiquidGlassActivity extends StatefulWidget {
  /// Spinner size style.
  final LiquidActivityStyle style;

  /// Corner radius of the glass capsule.
  final double cornerRadius;

  /// Spinner color.
  final Color? color;

  /// Whether the indicator hides when stopped.
  final bool hidesWhenStopped;

  /// Whether to start animating immediately.
  final bool animating;

  /// Optional label next to the spinner.
  final String? label;

  /// Height of the view.
  final double height;

  /// Width of the view.
  final double width;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassActivity].
  const NativeLiquidGlassActivity({
    super.key,
    this.style = LiquidActivityStyle.medium,
    this.cornerRadius = 16.0,
    this.color,
    this.hidesWhenStopped = true,
    this.animating = true,
    this.label,
    this.height = 48.0,
    this.width = 100.0,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassActivity> createState() =>
      _NativeLiquidGlassActivityState();
}

class _NativeLiquidGlassActivityState
    extends State<NativeLiquidGlassActivity> {
  MethodChannel? _channel;

  /// Starts the spinner animation.
  void start() => _channel?.invokeMethod('start', null);

  /// Stops the spinner animation.
  void stop() => _channel?.invokeMethod('stop', null);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    int? colorValue;
    if (widget.color != null) {
      final c = widget.color!;
      colorValue =
          ((c.a * 255).toInt() << 24) |
          ((c.r * 255).toInt() << 16) |
          ((c.g * 255).toInt() << 8) |
          (c.b * 255).toInt();
    }

    final styleName = switch (widget.style) {
      LiquidActivityStyle.large => 'large',
      LiquidActivityStyle.medium => 'medium',
    };

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: UiKitView(
        viewType: 'liquidify/activity',
        creationParams: {
          'style': styleName,
          'cornerRadius': widget.cornerRadius,
          'color': colorValue,
          'hidesWhenStopped': widget.hidesWhenStopped,
          'animating': widget.animating,
          'label': widget.label,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/activity_$viewId');
  }
}
