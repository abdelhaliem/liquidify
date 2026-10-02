import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/liquid_glass_options.dart';
import '../native/native_liquid_glass_tab_bar.dart';
import 'liquid_glass_container.dart';

/// An Apple-style frosted Liquid Glass bottom navigation bar.
///
/// **Hybrid Rendering:**
/// - On **iOS**: Uses a native `UITabBar` Platform View that automatically
///   adopts Liquid Glass on iOS 26+ for pixel-perfect Apple fidelity.
/// - On **other platforms**: Uses Flutter's `LiquidGlassContainer` with
///   `BackdropFilter` for a cross-platform frosted glass approximation.
class LiquidBottomNavigationBar extends StatelessWidget {
  /// The navigation items.
  final List<BottomNavigationBarItem> items;

  /// Called when an item is tapped.
  final ValueChanged<int>? onTap;

  /// The active item index.
  final int currentIndex;

  /// Color for the selected item.
  final Color? selectedItemColor;

  /// Color for unselected items.
  final Color? unselectedItemColor;

  /// Size of the icons. Defaults to 24.0.
  final double iconSize;

  /// Font size for selected labels. Defaults to 12.0.
  final double selectedFontSize;

  /// Font size for unselected labels. Defaults to 12.0.
  final double unselectedFontSize;

  /// Whether to show selected labels. Defaults to true.
  final bool showSelectedLabels;

  /// Whether to show unselected labels. Defaults to true.
  final bool showUnselectedLabels;

  /// Custom Liquid Glass options.
  final LiquidGlassOptions? options;

  /// Creates a [LiquidBottomNavigationBar].
  const LiquidBottomNavigationBar({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.iconSize = 24.0,
    this.selectedFontSize = 12.0,
    this.unselectedFontSize = 12.0,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    // Use native UITabBar on iOS for real Liquid Glass
    if (_shouldUseNative) {
      return _buildNativeTabBar(context);
    }

    return _buildFlutterTabBar(context);
  }

  bool get _shouldUseNative {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// Builds the native iOS UITabBar via Platform Views.
  Widget _buildNativeTabBar(BuildContext context) {
    final nativeItems = items.map((item) {
      // Map Material Icons to SF Symbols
      final iconName = _materialIconToSFSymbol(item.icon);
      final activeIconName = _materialIconToSFSymbol(item.activeIcon);

      return NativeTabBarItem(
        label: item.label ?? '',
        icon: iconName,
        activeIcon: activeIconName != iconName
            ? activeIconName
            : '$iconName.fill',
      );
    }).toList();

    return SafeArea(
      child: NativeLiquidGlassTabBar(
        items: nativeItems,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        height: 49.0,
        fallback: _buildFlutterTabBar(context),
      ),
    );
  }

  /// Maps common Material Icons to iOS SF Symbol names.
  String _materialIconToSFSymbol(Widget iconWidget) {
    if (iconWidget is Icon && iconWidget.icon != null) {
      final iconData = iconWidget.icon!;
      return _iconDataToSFSymbol(iconData);
    }
    return 'circle';
  }

  String _iconDataToSFSymbol(IconData iconData) {
    // Common mappings from Material Icons to SF Symbols
    final mappings = <int, String>{
      Icons.home.codePoint: 'house',
      Icons.home_outlined.codePoint: 'house',
      Icons.settings.codePoint: 'gear',
      Icons.settings_outlined.codePoint: 'gear',
      Icons.search.codePoint: 'magnifyingglass',
      Icons.person.codePoint: 'person',
      Icons.person_outline.codePoint: 'person',
      Icons.favorite.codePoint: 'heart.fill',
      Icons.favorite_border.codePoint: 'heart',
      Icons.star.codePoint: 'star.fill',
      Icons.star_border.codePoint: 'star',
      Icons.widgets.codePoint: 'square.grid.2x2.fill',
      Icons.widgets_outlined.codePoint: 'square.grid.2x2',
      Icons.palette.codePoint: 'paintpalette.fill',
      Icons.palette_outlined.codePoint: 'paintpalette',
      Icons.notifications.codePoint: 'bell.fill',
      Icons.notifications_outlined.codePoint: 'bell',
      Icons.chat.codePoint: 'message.fill',
      Icons.chat_outlined.codePoint: 'message',
      Icons.shopping_cart.codePoint: 'cart.fill',
      Icons.shopping_cart_outlined.codePoint: 'cart',
      Icons.map.codePoint: 'map.fill',
      Icons.map_outlined.codePoint: 'map',
      Icons.camera.codePoint: 'camera.fill',
      Icons.camera_outlined.codePoint: 'camera',
      Icons.photo.codePoint: 'photo.fill',
      Icons.photo_outlined.codePoint: 'photo',
      Icons.music_note.codePoint: 'music.note',
      Icons.play_arrow.codePoint: 'play.fill',
      Icons.pause.codePoint: 'pause.fill',
      Icons.add.codePoint: 'plus',
      Icons.remove.codePoint: 'minus',
      Icons.close.codePoint: 'xmark',
      Icons.check.codePoint: 'checkmark',
      Icons.share.codePoint: 'square.and.arrow.up',
      Icons.bookmark.codePoint: 'bookmark.fill',
      Icons.bookmark_border.codePoint: 'bookmark',
      Icons.cloud.codePoint: 'cloud.fill',
      Icons.cloud_outlined.codePoint: 'cloud',
      Icons.download.codePoint: 'arrow.down.circle',
      Icons.upload.codePoint: 'arrow.up.circle',
      Icons.lock.codePoint: 'lock.fill',
      Icons.lock_outlined.codePoint: 'lock',
      Icons.phone.codePoint: 'phone.fill',
      Icons.phone_outlined.codePoint: 'phone',
      Icons.email.codePoint: 'envelope.fill',
      Icons.email_outlined.codePoint: 'envelope',
      Icons.calendar_today.codePoint: 'calendar',
      Icons.info.codePoint: 'info.circle.fill',
      Icons.info_outline.codePoint: 'info.circle',
      Icons.warning.codePoint: 'exclamationmark.triangle.fill',
      Icons.warning_outlined.codePoint: 'exclamationmark.triangle',
      Icons.error.codePoint: 'xmark.circle.fill',
      Icons.error_outline.codePoint: 'xmark.circle',
    };

    return mappings[iconData.codePoint] ?? 'circle';
  }

  /// Builds the Flutter-based frosted glass tab bar (cross-platform fallback).
  Widget _buildFlutterTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveSelectedColor =
        selectedItemColor ??
        theme.bottomNavigationBarTheme.selectedItemColor ??
        theme.colorScheme.primary;

    final effectiveUnselectedColor =
        unselectedItemColor ??
        theme.bottomNavigationBarTheme.unselectedItemColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.55)
            : Colors.black.withValues(alpha: 0.45));

    final radius = options?.borderRadius ?? BorderRadius.circular(24.0);
    final margin =
        options?.margin ??
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

    return SafeArea(
      child: Padding(
        padding: margin,
        child: LiquidGlassContainer(
          useNative: false,
          options: (options ?? const LiquidGlassOptions()).copyWith(
            borderRadius: radius,
            blur: options?.blur ?? 24.0,
            opacity: options?.opacity ?? 0.78,
          ),
          borderRadius: radius,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              final color = isSelected
                  ? effectiveSelectedColor
                  : effectiveUnselectedColor;

              final showLabel = isSelected
                  ? showSelectedLabels
                  : showUnselectedLabels;

              final iconWidget = isSelected ? (item.activeIcon) : item.icon;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap != null ? () => onTap!(index) : null,
                  child: Semantics(
                    selected: isSelected,
                    button: true,
                    label: item.label,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      decoration: isSelected
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: effectiveSelectedColor.withValues(
                                alpha: isDark ? 0.15 : 0.10,
                              ),
                            )
                          : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconTheme.merge(
                            data: IconThemeData(color: color, size: iconSize),
                            child: iconWidget,
                          ),
                          if (showLabel && item.label != null) ...[
                            const SizedBox(height: 4.0),
                            Text(
                              item.label!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: color,
                                fontSize: isSelected
                                    ? selectedFontSize
                                    : unselectedFontSize,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
