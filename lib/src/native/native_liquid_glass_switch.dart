import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS UISwitch embedded via Platform Views.
///
/// On iOS 26+, the UISwitch automatically adopts Liquid Glass styling.
class NativeLiquidGlassSwitch extends StatefulWidget {
  /// Whether the switch is on.
  final bool value;

  /// Called when the switch is toggled.
  final ValueChanged<bool>? onChanged;

  /// Active tint color.
  final Color? activeColor;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassSwitch].
  const NativeLiquidGlassSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassSwitch> createState() =>
      _NativeLiquidGlassSwitchState();
}

class _NativeLiquidGlassSwitchState extends State<NativeLiquidGlassSwitch> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ??
          Switch(value: widget.value, onChanged: widget.onChanged);
    }

    return SizedBox(
      width: 51,
      height: 31,
      child: UiKitView(
        viewType: 'liquidify/switch',
        creationParams: {
          'value': widget.value,
          'activeColor': _colorToHex(widget.activeColor),
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/switch_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onChanged') {
        final val = call.arguments as bool;
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
