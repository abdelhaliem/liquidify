import 'package:flutter/material.dart';
import '../core/liquid_glass_engine.dart';
import '../core/liquid_glass_options.dart';

/// Extension on [BottomNavigationBar] providing Liquid Glass transformation.
extension BottomNavigationBarLiquidGlass on BottomNavigationBar {
  /// Converts this [BottomNavigationBar] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [NavigationBar] providing Liquid Glass transformation.
extension NavigationBarLiquidGlass on NavigationBar {
  /// Converts this [NavigationBar] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [NavigationRail] providing Liquid Glass transformation.
extension NavigationRailLiquidGlass on NavigationRail {
  /// Converts this [NavigationRail] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}

/// Extension on [TabBar] providing Liquid Glass transformation.
extension TabBarLiquidGlass on TabBar {
  /// Converts this [TabBar] into its Liquid Glass equivalent.
  Widget liquidGlass({LiquidGlassOptions? options}) {
    return LiquidGlassEngine.convert(this, options: options);
  }
}
