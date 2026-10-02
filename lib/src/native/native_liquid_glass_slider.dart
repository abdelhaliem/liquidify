import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS UISlider embedded via Platform Views.
///
/// On iOS 26+, the UISlider automatically adopts Liquid Glass styling.
/// On non-iOS platforms, returns [fallback] or a standard [Slider].
class NativeLiquidGlassSlider extends StatefulWidget {
  /// The current value.
  final double value;

  /// Called when the value changes.
  final ValueChanged<double>? onChanged;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Active color tint.
  final Color? activeColor;

  /// Inactive color tint.
  final Color? inactiveColor;

  /// Height of the view.
  final double height;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassSlider].
  const NativeLiquidGlassSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.activeColor,
    this.inactiveColor,
    this.height = 34.0,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassSlider> createState() =>
      _NativeLiquidGlassSliderState();
}

class _NativeLiquidGlassSliderState extends State<NativeLiquidGlassSlider> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ??
          Slider(
            value: widget.value,
            onChanged: widget.onChanged,
            min: widget.min,
            max: widget.max,
          );
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/slider',
        creationParams: {
          'value': widget.value,
          'min': widget.min,
          'max': widget.max,
          'activeColor': _colorToHex(widget.activeColor),
          'inactiveColor': _colorToHex(widget.inactiveColor),
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/slider_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onChanged') {
        final val = call.arguments as double;
        widget.onChanged?.call(val);
      }
    });
  }

  int? _colorToHex(Color? color) {
    if (color == null) return null;
    return ((color.a * 255).toInt() << 24) |
        ((color.r * 255).toInt() << 16) |
        ((color.g * 255).toInt() << 8) |
        (color.b * 255).toInt();
  }
}
