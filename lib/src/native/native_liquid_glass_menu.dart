import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Data class representing a menu item.
@immutable
class NativeMenuItem {
  /// Label text for the menu item.
  final String label;

  /// SF Symbol icon name (e.g. 'trash', 'doc.on.doc').
  final String? icon;

  /// Whether the item is destructive (shown in red).
  final bool isDestructive;

  /// Creates a [NativeMenuItem].
  const NativeMenuItem({
    required this.label,
    this.icon,
    this.isDestructive = false,
  });

  /// Converts to a map for platform channel encoding.
  Map<String, dynamic> toMap() => {
    'label': label,
    'icon': icon,
    'isDestructive': isDestructive,
  };
}

/// A native iOS context menu trigger with Liquid Glass background.
///
/// Shows a `UIMenu` on tap or long-press. On iOS 26+, the trigger
/// button uses `UIGlassEffect` for the authentic glass look. Items
/// support SF Symbol icons and destructive styling.
class NativeLiquidGlassMenu extends StatefulWidget {
  /// Title text on the trigger button.
  final String title;

  /// SF Symbol icon for the trigger button.
  final String? icon;

  /// Menu items.
  final List<NativeMenuItem> items;

  /// Corner radius of the trigger button.
  final double cornerRadius;

  /// Height of the trigger view.
  final double height;

  /// Called when a menu item is selected, with the item index.
  final ValueChanged<int>? onItemSelected;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassMenu].
  const NativeLiquidGlassMenu({
    super.key,
    this.title = '',
    this.icon,
    required this.items,
    this.cornerRadius = 12.0,
    this.height = 44.0,
    this.onItemSelected,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassMenu> createState() =>
      _NativeLiquidGlassMenuState();
}

class _NativeLiquidGlassMenuState
    extends State<NativeLiquidGlassMenu> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/menu',
        creationParams: {
          'title': widget.title,
          'icon': widget.icon,
          'cornerRadius': widget.cornerRadius,
          'items':
              widget.items.map((i) => i.toMap()).toList(),
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/menu_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onItemSelected') {
        widget.onItemSelected?.call(call.arguments as int);
      }
    });
  }
}
