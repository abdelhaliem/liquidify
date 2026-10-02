import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [CircularProgressIndicator] to Liquid Glass styling.
class CircularProgressIndicatorLiquidAdapter
    extends LiquidGlassAdapter<CircularProgressIndicator> {
  const CircularProgressIndicatorLiquidAdapter();

  @override
  Widget build(CircularProgressIndicator widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final radius = BorderRadius.circular(28.0);

        return LiquidGlassContainer(
          options: options.copyWith(
            borderRadius: radius,
            blur: options.blur ?? 16.0,
            opacity: options.opacity ?? 0.75,
          ),
          borderRadius: radius,
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(width: 24.0, height: 24.0, child: widget),
        );
      },
    );
  }
}

/// Adapts [LinearProgressIndicator] to Liquid Glass styling.
class LinearProgressIndicatorLiquidAdapter
    extends LiquidGlassAdapter<LinearProgressIndicator> {
  const LinearProgressIndicatorLiquidAdapter();

  @override
  Widget build(LinearProgressIndicator widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final radius = options.borderRadius ?? BorderRadius.circular(8.0);

        return ClipRRect(
          borderRadius: radius.resolve(Directionality.of(context)),
          child: LiquidGlassContainer(
            options: options.copyWith(
              borderRadius: radius,
              blur: options.blur ?? 12.0,
            ),
            borderRadius: radius,
            child: widget,
          ),
        );
      },
    );
  }
}
