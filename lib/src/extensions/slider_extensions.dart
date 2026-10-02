import 'package:flutter/material.dart';
import '../core/liquid_glass_engine.dart';
import '../core/liquid_glass_options.dart';

/// Extension on [Slider] providing Liquid Glass transformation.
extension SliderLiquidGlass on Slider {
  /// Converts this [Slider] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [RangeSlider] providing Liquid Glass transformation.
extension RangeSliderLiquidGlass on RangeSlider {
  /// Converts this [RangeSlider] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}
