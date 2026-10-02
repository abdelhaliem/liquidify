import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that renders a native iOS tab bar using Platform Views.
///
/// On iOS 26+, the tab bar automatically renders with Apple's Liquid Glass
/// material. On older iOS versions, it uses the standard system blur.
/// On non-iOS platforms, it returns [fallback] or an empty [SizedBox].
class NativeLiquidGlassTabBar extends StatefulWidget {
  /// The tab bar items to display.
  final List<NativeTabBarItem> items;

  /// The currently selected tab index.
  final int currentIndex;

  /// Called when a tab is tapped.
  final ValueChanged<int>? onTap;

  /// Color for the selected tab item.
  final Color? selectedItemColor;

  /// Color for unselected tab items.
  final Color? unselectedItemColor;

  /// Height of the tab bar. Defaults to 49 (iOS standard).
  final double height;

  /// Fallback widget for non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassTabBar].
  const NativeLiquidGlassTabBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.height = 49.0,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassTabBar> createState() =>
      _NativeLiquidGlassTabBarState();
}

class _NativeLiquidGlassTabBarState extends State<NativeLiquidGlassTabBar> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    int? selectedHex;
    if (widget.selectedItemColor != null) {
      final c = widget.selectedItemColor!;
      selectedHex =
          ((c.a * 255).toInt() << 24) |
          ((c.r * 255).toInt() << 16) |
          ((c.g * 255).toInt() << 8) |
          (c.b * 255).toInt();
    }

    int? unselectedHex;
    if (widget.unselectedItemColor != null) {
      final c = widget.unselectedItemColor!;
      unselectedHex =
          ((c.a * 255).toInt() << 24) |
          ((c.r * 255).toInt() << 16) |
          ((c.g * 255).toInt() << 8) |
          (c.b * 255).toInt();
    }

    final creationParams = {
      'items': widget.items.map((item) => item.toMap()).toList(),
      'currentIndex': widget.currentIndex,
      'selectedColor': selectedHex,
      'unselectedColor': unselectedHex,
    };

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/tab_bar',
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      ),
    );
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('liquidify/tab_bar_$id');
    _channel!.setMethodCallHandler(_handleNativeCall);
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    if (call.method == 'onTabSelected') {
      final index = call.arguments as int;
      widget.onTap?.call(index);
    }
  }

  @override
  void didUpdateWidget(NativeLiquidGlassTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _channel?.invokeMethod('setSelectedIndex', widget.currentIndex);
    }
  }
}

/// Represents a single item in a [NativeLiquidGlassTabBar].
class NativeTabBarItem {
  /// The label shown below the icon.
  final String label;

  /// SF Symbol name for the icon (e.g. 'house', 'gear').
  final String icon;

  /// SF Symbol name for the active icon. If null, uses [icon].
  final String? activeIcon;

  /// Creates a [NativeTabBarItem].
  const NativeTabBarItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });

  /// Serializes to a map for the platform channel.
  Map<String, dynamic> toMap() => {
    'label': label,
    'icon': icon,
    'activeIcon': activeIcon,
  };
}
