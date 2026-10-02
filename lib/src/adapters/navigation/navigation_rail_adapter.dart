import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [NavigationRail] to Liquid Glass styling.
class NavigationRailLiquidAdapter extends LiquidGlassAdapter<NavigationRail> {
  const NavigationRailLiquidAdapter();

  @override
  Widget build(NavigationRail widget, LiquidGlassOptions options) {
    final radius = options.borderRadius ?? BorderRadius.circular(20.0);
    final margin =
        options.margin ??
        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0);

    return SafeArea(
      child: Padding(
        padding: margin,
        child: LiquidGlassContainer(
          options: options.copyWith(
            borderRadius: radius,
            blur: options.blur ?? 24.0,
            opacity: options.opacity ?? 0.80,
          ),
          borderRadius: radius,
          child: NavigationRailTheme(
            data: const NavigationRailThemeData(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            child: widget,
          ),
        ),
      ),
    );
  }
}
