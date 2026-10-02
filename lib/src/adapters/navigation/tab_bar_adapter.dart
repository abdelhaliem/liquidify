import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [TabBar] into a frosted glass segment control.
class TabBarLiquidAdapter extends LiquidGlassAdapter<TabBar> {
  const TabBarLiquidAdapter();

  @override
  Widget build(TabBar widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final radius = options.borderRadius ?? BorderRadius.circular(16.0);
        final indicatorRadius = BorderRadius.circular(12.0);

        final glassIndicator = BoxDecoration(
          borderRadius: indicatorRadius,
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.85),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6.0,
              offset: const Offset(0, 2),
            ),
          ],
        );

        return LiquidGlassContainer(
          options: options.copyWith(
            borderRadius: radius,
            padding: const EdgeInsets.all(4.0),
          ),
          borderRadius: radius,
          child: TabBar(
            key: widget.key,
            tabs: widget.tabs,
            controller: widget.controller,
            isScrollable: widget.isScrollable,
            padding: widget.padding,
            indicatorColor: Colors.transparent,
            indicator: widget.indicator ?? glassIndicator,
            indicatorSize: widget.indicatorSize ?? TabBarIndicatorSize.tab,
            labelColor: widget.labelColor ?? theme.colorScheme.primary,
            unselectedLabelColor:
                widget.unselectedLabelColor ??
                theme.colorScheme.onSurface.withValues(alpha: 0.60),
            labelStyle:
                widget.labelStyle ??
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
            unselectedLabelStyle:
                widget.unselectedLabelStyle ??
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
            dividerColor: Colors.transparent,
            onTap: widget.onTap,
          ),
        );
      },
    );
  }
}
