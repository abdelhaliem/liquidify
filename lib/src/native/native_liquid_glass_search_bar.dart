import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS UISearchBar embedded via Platform Views.
///
/// On iOS 26+, UISearchBar natively adopts Liquid Glass styling.
class NativeLiquidGlassSearchBar extends StatefulWidget {
  /// Initial text.
  final String? text;

  /// Placeholder text.
  final String? placeholder;

  /// Called when search text changes.
  final ValueChanged<String>? onChanged;

  /// Called when search button is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Height of the view.
  final double height;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassSearchBar].
  const NativeLiquidGlassSearchBar({
    super.key,
    this.text,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.height = 44.0,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassSearchBar> createState() =>
      _NativeLiquidGlassSearchBarState();
}

class _NativeLiquidGlassSearchBarState
    extends State<NativeLiquidGlassSearchBar> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/search_bar',
        creationParams: {
          'text': widget.text ?? '',
          'placeholder': widget.placeholder ?? 'Search...',
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/search_bar_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onChanged') {
        widget.onChanged?.call(call.arguments as String);
      } else if (call.method == 'onSubmitted') {
        widget.onSubmitted?.call(call.arguments as String? ?? '');
      }
    });
  }
}
