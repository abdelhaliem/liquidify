import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Data class representing a toolbar item.
@immutable
class NativeToolbarItem {
  /// SF Symbol icon name (e.g. 'square.and.arrow.up').
  final String icon;

  /// Accessibility label for the item.
  final String? label;

  /// Creates a [NativeToolbarItem].
  const NativeToolbarItem({
    required this.icon,
    this.label,
  });

  /// Converts to a map for platform channel encoding.
  Map<String, dynamic> toMap() => {
    'icon': icon,
    'label': label,
  };
}

/// A native iOS `UIToolbar` with Liquid Glass material.
///
/// On iOS 26+, the toolbar uses `UIGlassEffect` for the authentic
/// Apple glass toolbar look. Items are rendered as SF Symbol icons
/// with flexible spacing.
class NativeLiquidGlassToolbar extends StatefulWidget {
  /// Toolbar items (SF Symbol icons).
  final List<NativeToolbarItem> items;

  /// Optional tint color for icons.
  final Color? tintColor;

  /// Height of the toolbar.
  final double height;

  /// Called when a toolbar item is tapped, with the item index.
  final ValueChanged<int>? onItemTapped;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassToolbar].
  const NativeLiquidGlassToolbar({
    super.key,
    required this.items,
    this.tintColor,
    this.height = 44.0,
    this.onItemTapped,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassToolbar> createState() =>
      _NativeLiquidGlassToolbarState();
}

class _NativeLiquidGlassToolbarState
    extends State<NativeLiquidGlassToolbar> {
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
        viewType: 'liquidify/toolbar',
        creationParams: {
          'items':
              widget.items.map((i) => i.toMap()).toList(),
          'tintColor': tintColorValue,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/toolbar_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onItemTapped') {
        widget.onItemTapped?.call(call.arguments as int);
      }
    });
  }
}
