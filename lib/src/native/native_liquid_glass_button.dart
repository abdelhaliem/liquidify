import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS UIButton with glass background via Platform Views.
///
/// On iOS 26+, uses UIGlassEffect for authentic Liquid Glass look.
class NativeLiquidGlassButton extends StatefulWidget {
  /// Button title text.
  final String title;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// SF Symbol icon name.
  final String? iconName;

  /// Corner radius.
  final double cornerRadius;

  /// Height of the view.
  final double height;

  /// Button style: 'filled', 'outlined', 'text'.
  final String style;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassButton].
  const NativeLiquidGlassButton({
    super.key,
    required this.title,
    this.onPressed,
    this.iconName,
    this.cornerRadius = 12.0,
    this.height = 44.0,
    this.style = 'filled',
    this.fallback,
  });

  @override
  State<NativeLiquidGlassButton> createState() =>
      _NativeLiquidGlassButtonState();
}

class _NativeLiquidGlassButtonState extends State<NativeLiquidGlassButton> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ??
          ElevatedButton(
            onPressed: widget.onPressed,
            child: Text(widget.title),
          );
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/button',
        creationParams: {
          'title': widget.title,
          'cornerRadius': widget.cornerRadius,
          'style': widget.style,
          'icon': widget.iconName,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/button_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onPressed') {
        widget.onPressed?.call();
      }
    });
  }
}
