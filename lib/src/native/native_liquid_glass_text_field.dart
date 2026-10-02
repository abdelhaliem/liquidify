import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS UITextField with glass background via Platform Views.
class NativeLiquidGlassTextField extends StatefulWidget {
  /// Initial text value.
  final String? text;

  /// Placeholder text.
  final String? placeholder;

  /// Floating label text.
  final String? label;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when user submits.
  final ValueChanged<String>? onSubmitted;

  /// Corner radius.
  final double cornerRadius;

  /// Height of the view.
  final double height;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassTextField].
  const NativeLiquidGlassTextField({
    super.key,
    this.text,
    this.placeholder,
    this.label,
    this.onChanged,
    this.onSubmitted,
    this.cornerRadius = 12.0,
    this.height = 56.0,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassTextField> createState() =>
      _NativeLiquidGlassTextFieldState();
}

class _NativeLiquidGlassTextFieldState
    extends State<NativeLiquidGlassTextField> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/text_field',
        creationParams: {
          'text': widget.text ?? '',
          'placeholder': widget.placeholder ?? '',
          'label': widget.label,
          'cornerRadius': widget.cornerRadius,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/text_field_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onChanged') {
        widget.onChanged?.call(call.arguments as String);
      } else if (call.method == 'onSubmitted') {
        widget.onSubmitted?.call(call.arguments as String? ?? '');
      }
    });
  }
}
