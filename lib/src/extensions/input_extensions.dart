import 'package:flutter/material.dart';
import '../core/liquid_glass_engine.dart';
import '../core/liquid_glass_options.dart';

/// Extension on [TextField] providing Liquid Glass transformation.
extension TextFieldLiquidGlass on TextField {
  /// Converts this [TextField] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [TextFormField] providing Liquid Glass transformation.
extension TextFormFieldLiquidGlass on TextFormField {
  /// Converts this [TextFormField] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [SearchBar] providing Liquid Glass transformation.
extension SearchBarLiquidGlass on SearchBar {
  /// Converts this [SearchBar] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [DropdownButton] providing Liquid Glass transformation.
extension DropdownButtonLiquidGlass<T> on DropdownButton<T> {
  /// Converts this [DropdownButton] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}
