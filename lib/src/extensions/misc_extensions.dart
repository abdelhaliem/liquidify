import 'package:flutter/material.dart';
import '../core/liquid_glass_engine.dart';
import '../core/liquid_glass_options.dart';

/// Extension on [Chip] providing Liquid Glass transformation.
extension ChipLiquidGlass on Chip {
  /// Converts this [Chip] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [FilterChip] providing Liquid Glass transformation.
extension FilterChipLiquidGlass on FilterChip {
  /// Converts this [FilterChip] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [ChoiceChip] providing Liquid Glass transformation.
extension ChoiceChipLiquidGlass on ChoiceChip {
  /// Converts this [ChoiceChip] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [ActionChip] providing Liquid Glass transformation.
extension ActionChipLiquidGlass on ActionChip {
  /// Converts this [ActionChip] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [CircularProgressIndicator] providing Liquid Glass transformation.
extension CircularProgressIndicatorLiquidGlass on CircularProgressIndicator {
  /// Converts this [CircularProgressIndicator] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [LinearProgressIndicator] providing Liquid Glass transformation.
extension LinearProgressIndicatorLiquidGlass on LinearProgressIndicator {
  /// Converts this [LinearProgressIndicator] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}
