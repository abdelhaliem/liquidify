import 'package:flutter/material.dart';
import 'liquid_glass_options.dart';

/// Provides ambient [LiquidGlassOptions] down the widget tree.
class LiquidGlassTheme extends InheritedTheme {
  /// The ambient options provided to child widgets.
  final LiquidGlassOptions options;

  /// Creates a [LiquidGlassTheme].
  const LiquidGlassTheme({
    super.key,
    required this.options,
    required super.child,
  });

  /// Retrieves the ambient [LiquidGlassOptions], or returns default options if none exists.
  static LiquidGlassOptions of(BuildContext context) {
    return maybeOf(context) ?? resolveDefault(context);
  }

  /// Retrieves the ambient [LiquidGlassOptions] if available in [context].
  static LiquidGlassOptions? maybeOf(BuildContext context) {
    final theme = context
        .dependOnInheritedWidgetOfExactType<LiquidGlassTheme>();
    return theme?.options;
  }

  /// Resolves standard Apple Liquid Glass aesthetic defaults based on the current
  /// brightness (Light or Dark mode).
  static LiquidGlassOptions resolveDefault(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return LiquidGlassOptions(
        blur: 20.0,
        opacity: 0.70,
        tint: const Color(0xFF1A1A1E).withValues(alpha: 0.65),
        borderWidth: 1.0,
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.28),
            Colors.white.withValues(alpha: 0.06),
          ],
        ),
        glassGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withValues(alpha: 0.08), Colors.transparent],
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
        refraction: 0.30,
        interactive: true,
        force: false,
        enabled: true,
      );
    }

    return LiquidGlassOptions(
      blur: 20.0,
      opacity: 0.68,
      tint: Colors.white.withValues(alpha: 0.35),
      borderWidth: 1.0,
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.75),
          Colors.white.withValues(alpha: 0.18),
        ],
      ),
      glassGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.05),
        ],
      ),
      shadows: [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.08),
          blurRadius: 18,
          offset: const Offset(0, 8),
          spreadRadius: -2,
        ),
      ],
      refraction: 0.40,
      interactive: true,
      force: false,
      enabled: true,
    );
  }

  /// Merges ambient options and theme brightness defaults with any widget-specific [overrides].
  static LiquidGlassOptions resolve(
    BuildContext context, {
    LiquidGlassOptions? overrides,
  }) {
    final base = of(context);
    if (overrides == null) return base;
    return base.merge(overrides);
  }

  @override
  bool updateShouldNotify(LiquidGlassTheme oldWidget) {
    return options != oldWidget.options;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return LiquidGlassTheme(options: options, child: child);
  }
}
