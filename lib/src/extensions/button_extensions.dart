import 'package:flutter/material.dart';
import '../core/liquid_glass_engine.dart';
import '../core/liquid_glass_options.dart';

/// Extension on [ElevatedButton] providing Liquid Glass transformation.
extension ElevatedButtonLiquidGlass on ElevatedButton {
  /// Converts this [ElevatedButton] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [FilledButton] providing Liquid Glass transformation.
extension FilledButtonLiquidGlass on FilledButton {
  /// Converts this [FilledButton] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [OutlinedButton] providing Liquid Glass transformation.
extension OutlinedButtonLiquidGlass on OutlinedButton {
  /// Converts this [OutlinedButton] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [TextButton] providing Liquid Glass transformation.
extension TextButtonLiquidGlass on TextButton {
  /// Converts this [TextButton] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [IconButton] providing Liquid Glass transformation.
extension IconButtonLiquidGlass on IconButton {
  /// Converts this [IconButton] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [FloatingActionButton] providing Liquid Glass transformation.
extension FloatingActionButtonLiquidGlass on FloatingActionButton {
  /// Converts this [FloatingActionButton] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [SegmentedButton] providing Liquid Glass transformation.
extension SegmentedButtonLiquidGlass<T> on SegmentedButton<T> {
  /// Converts this [SegmentedButton] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}
