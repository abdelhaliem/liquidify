import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A native iOS UINavigationBar embedded via Platform Views.
///
/// On iOS 26+, UINavigationBar natively adopts the Liquid Glass material.
/// On earlier versions, it uses the system chrome blur appearance.
class NativeLiquidGlassNavBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Navigation bar title.
  final String title;

  /// Tint color for the navigation bar items.
  final Color? tintColor;

  /// Height of the navigation bar. Defaults to 44.0 (standard iOS nav bar).
  final double height;

  /// Fallback widget when not on iOS.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassNavBar].
  const NativeLiquidGlassNavBar({
    super.key,
    required this.title,
    this.tintColor,
    this.height = 44.0,
    this.fallback,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return fallback ?? SizedBox(height: height);
    }

    final topPadding = MediaQuery.paddingOf(context).top;
    final totalHeight = height + topPadding;

    return SizedBox(
      height: totalHeight,
      child: UiKitView(
        viewType: 'liquidify/nav_bar',
        creationParams: {'title': title, 'tintColor': tintColor?.toARGB32()},
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
