import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS bottom sheet with Liquid Glass material.
///
/// On iOS 26+, uses `UIGlassEffect` for the authentic Apple glass
/// sheet look. Includes a drag handle and rounded top corners.
class NativeLiquidGlassSheet extends StatefulWidget {
  /// Corner radius of the top corners.
  final double cornerRadius;

  /// Whether to show the drag handle indicator.
  final bool showHandle;

  /// Optional tint color for the glass surface.
  final Color? tintColor;

  /// Height of the sheet view.
  final double height;

  /// Called when the sheet is dismissed.
  final VoidCallback? onDismiss;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassSheet].
  const NativeLiquidGlassSheet({
    super.key,
    this.cornerRadius = 20.0,
    this.showHandle = true,
    this.tintColor,
    this.height = 300.0,
    this.onDismiss,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassSheet> createState() =>
      _NativeLiquidGlassSheetState();
}

class _NativeLiquidGlassSheetState
    extends State<NativeLiquidGlassSheet> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    int? tintColorValue;
    if (widget.tintColor != null) {
      final c = widget.tintColor!;
      tintColorValue =
          ((c.a * 255).toInt() << 24) |
          ((c.r * 255).toInt() << 16) |
          ((c.g * 255).toInt() << 8) |
          (c.b * 255).toInt();
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/sheet',
        creationParams: {
          'cornerRadius': widget.cornerRadius,
          'showHandle': widget.showHandle,
          'tintColor': tintColorValue,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/sheet_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onDismiss') {
        widget.onDismiss?.call();
      }
    });
  }
}
