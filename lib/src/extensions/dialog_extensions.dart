import 'package:flutter/material.dart';
import '../core/liquid_glass_engine.dart';
import '../core/liquid_glass_options.dart';

/// Extension on [AlertDialog] providing Liquid Glass transformation.
extension AlertDialogLiquidGlass on AlertDialog {
  /// Converts this [AlertDialog] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [Dialog] providing Liquid Glass transformation.
extension DialogLiquidGlass on Dialog {
  /// Converts this [Dialog] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}
