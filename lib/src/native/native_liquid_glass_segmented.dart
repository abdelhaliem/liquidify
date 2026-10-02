import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS UISegmentedControl via Platform Views.
///
/// On iOS 26+, UISegmentedControl adopts Liquid Glass material.
class NativeLiquidGlassSegmented extends StatefulWidget {
  /// The segment labels.
  final List<String> segments;

  /// Currently selected index.
  final int selectedIndex;

  /// Called when user selects a segment.
  final ValueChanged<int>? onChanged;

  /// Height of the view.
  final double height;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassSegmented].
  const NativeLiquidGlassSegmented({
    super.key,
    required this.segments,
    this.selectedIndex = 0,
    this.onChanged,
    this.height = 32.0,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassSegmented> createState() =>
      _NativeLiquidGlassSegmentedState();
}

class _NativeLiquidGlassSegmentedState
    extends State<NativeLiquidGlassSegmented> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/segmented',
        creationParams: {
          'segments': widget.segments,
          'selectedIndex': widget.selectedIndex,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/segmented_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onChanged') {
        widget.onChanged?.call(call.arguments as int);
      }
    });
  }
}
