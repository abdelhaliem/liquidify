import 'package:flutter/material.dart';
import '../core/liquid_glass_engine.dart';
import '../core/liquid_glass_options.dart';

/// Extension on [Switch] providing Liquid Glass transformation.
extension SwitchLiquidGlass on Switch {
  /// Converts this [Switch] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [Checkbox] providing Liquid Glass transformation.
extension CheckboxLiquidGlass on Checkbox {
  /// Converts this [Checkbox] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [Radio] providing Liquid Glass transformation.
extension RadioLiquidGlass<T> on Radio<T> {
  /// Converts this [Radio] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [SwitchListTile] providing Liquid Glass transformation.
extension SwitchListTileLiquidGlass on SwitchListTile {
  /// Converts this [SwitchListTile] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [CheckboxListTile] providing Liquid Glass transformation.
extension CheckboxListTileLiquidGlass on CheckboxListTile {
  /// Converts this [CheckboxListTile] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [RadioListTile] providing Liquid Glass transformation.
extension RadioListTileLiquidGlass<T> on RadioListTile<T> {
  /// Converts this [RadioListTile] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}
