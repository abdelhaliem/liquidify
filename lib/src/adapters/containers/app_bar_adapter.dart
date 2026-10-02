import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_app_bar.dart';

/// Adapts [AppBar] to an Apple-style frosted Liquid Glass app bar.
class AppBarLiquidAdapter extends LiquidGlassAdapter<AppBar> {
  const AppBarLiquidAdapter();

  @override
  Widget build(AppBar widget, LiquidGlassOptions options) {
    return LiquidAppBar(appBar: widget, options: options);
  }
}
