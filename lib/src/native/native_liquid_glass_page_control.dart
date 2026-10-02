import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS `UIPageControl` with Liquid Glass pill background.
///
/// On iOS 26+, the page indicator uses `UIGlassEffect` for the
/// authentic glass dot-indicator look. Supports custom active/inactive
/// colors and responds to user taps to change pages.
class NativeLiquidGlassPageControl extends StatefulWidget {
  /// Total number of pages.
  final int numberOfPages;

  /// Currently selected page index.
  final int currentPage;

  /// Corner radius of the glass pill.
  final double cornerRadius;

  /// Active dot color.
  final Color? activeColor;

  /// Inactive dot color.
  final Color? inactiveColor;

  /// Height of the view.
  final double height;

  /// Called when the user taps to change page.
  final ValueChanged<int>? onPageChanged;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassPageControl].
  const NativeLiquidGlassPageControl({
    super.key,
    required this.numberOfPages,
    this.currentPage = 0,
    this.cornerRadius = 14.0,
    this.activeColor,
    this.inactiveColor,
    this.height = 36.0,
    this.onPageChanged,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassPageControl> createState() =>
      _NativeLiquidGlassPageControlState();
}

class _NativeLiquidGlassPageControlState
    extends State<NativeLiquidGlassPageControl> {
  MethodChannel? _channel;

  @override
  void didUpdateWidget(NativeLiquidGlassPageControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      _channel?.invokeMethod(
        'setCurrentPage',
        widget.currentPage,
      );
    }
    if (oldWidget.numberOfPages != widget.numberOfPages) {
      _channel?.invokeMethod(
        'setNumberOfPages',
        widget.numberOfPages,
      );
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
        viewType: 'liquidify/page_control',
        creationParams: {
          'numberOfPages': widget.numberOfPages,
          'currentPage': widget.currentPage,
          'cornerRadius': widget.cornerRadius,
          'activeColor': _colorToInt(widget.activeColor),
          'inactiveColor': _colorToInt(widget.inactiveColor),
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/page_control_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onPageChanged') {
        widget.onPageChanged?.call(call.arguments as int);
      }
    });
  }

  static int? _colorToInt(Color? color) {
    if (color == null) return null;
    return ((color.a * 255).toInt() << 24) |
        ((color.r * 255).toInt() << 16) |
        ((color.g * 255).toInt() << 8) |
        (color.b * 255).toInt();
  }
}
