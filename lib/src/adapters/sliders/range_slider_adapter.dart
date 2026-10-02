import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [RangeSlider] to Liquid Glass styling.
class RangeSliderLiquidAdapter extends LiquidGlassAdapter<RangeSlider> {
  const RangeSliderLiquidAdapter();

  @override
  Widget build(RangeSlider widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final radius = options.borderRadius ?? BorderRadius.circular(16.0);

        return LiquidGlassContainer(
          options: options.copyWith(
            borderRadius: radius,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
          ),
          borderRadius: radius,
          child: widget,
        );
      },
    );
  }
}
