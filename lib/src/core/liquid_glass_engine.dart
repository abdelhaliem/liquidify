import 'package:flutter/widgets.dart';
import 'liquid_glass_options.dart';
import 'liquid_glass_transformer.dart';

/// The core conversion engine for the Liquid Glass framework.
class LiquidGlassEngine {
  LiquidGlassEngine._();

  /// Converts a standard Flutter [widget] into its Liquid Glass-styled equivalent.
  ///
  /// ```dart
  /// LiquidGlassEngine.convert(
  ///   BottomNavigationBar(items: [...]),
  ///   options: LiquidGlassOptions(blur: 24),
  /// );
  /// ```
  static Widget convert<T extends Widget>(
    T widget, {
    LiquidGlassOptions? options,
  }) {
    return LiquidGlassTransformer<T>(widget: widget, options: options);
  }
}
