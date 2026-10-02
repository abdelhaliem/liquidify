import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts Material 3 [NavigationBar] to Liquid Glass styling.
class NavigationBarLiquidAdapter extends LiquidGlassAdapter<NavigationBar> {
  const NavigationBarLiquidAdapter();

  @override
  Widget build(NavigationBar widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final radius = options.borderRadius ?? BorderRadius.circular(24.0);
        final margin =
            options.margin ??
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

        final adaptedTheme = NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          indicatorColor:
              widget.indicatorColor ??
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
        );

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
              child: NavigationBarTheme(data: adaptedTheme, child: widget),
            ),
          ),
        );
      },
    );
  }
}
