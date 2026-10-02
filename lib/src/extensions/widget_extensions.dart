import 'package:flutter/widgets.dart';
import '../core/liquid_glass_engine.dart';
import '../core/liquid_glass_options.dart';

/// Generic extension on [Widget] providing fallback or custom-registered Liquid Glass transformation.
extension LiquidGlassWidgetExtension on Widget {
  /// Converts any Flutter [Widget] into its Liquid Glass equivalent using the
  /// [LiquidGlassRegistry].
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}
