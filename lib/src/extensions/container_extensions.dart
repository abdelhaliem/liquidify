import 'package:flutter/material.dart';
import '../core/liquid_glass_engine.dart';
import '../core/liquid_glass_options.dart';
import '../widgets/liquid_app_bar.dart';

/// Extension on [AppBar] providing Liquid Glass transformation.
extension AppBarLiquidGlass on AppBar {
  /// Converts this [AppBar] into a Liquid Glass [PreferredSizeWidget].
  PreferredSizeWidget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidAppBar(appBar: this, options: options);
  }
}

/// Extension on [SliverAppBar] providing Liquid Glass transformation.
extension SliverAppBarLiquidGlass on SliverAppBar {
  /// Converts this [SliverAppBar] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [Card] providing Liquid Glass transformation.
extension CardLiquidGlass on Card {
  /// Converts this [Card] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [ListTile] providing Liquid Glass transformation.
extension ListTileLiquidGlass on ListTile {
  /// Converts this [ListTile] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [Container] providing Liquid Glass transformation.
extension ContainerLiquidGlass on Container {
  /// Converts this [Container] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}
