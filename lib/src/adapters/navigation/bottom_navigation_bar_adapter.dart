import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_bottom_navigation_bar.dart';

/// Adapts [BottomNavigationBar] to an Apple-style frosted Liquid Glass bottom bar.
class BottomNavigationBarLiquidAdapter
    extends LiquidGlassAdapter<BottomNavigationBar> {
  const BottomNavigationBarLiquidAdapter();

  @override
  Widget build(BottomNavigationBar widget, LiquidGlassOptions options) {
    return LiquidBottomNavigationBar(
      key: widget.key,
      items: widget.items,
      onTap: widget.onTap,
      currentIndex: widget.currentIndex,
      selectedItemColor: widget.selectedItemColor,
      unselectedItemColor: widget.unselectedItemColor,
      iconSize: widget.iconSize,
      selectedFontSize: widget.selectedFontSize,
      unselectedFontSize: widget.unselectedFontSize,
      showSelectedLabels: widget.showSelectedLabels ?? true,
      showUnselectedLabels: widget.showUnselectedLabels ?? true,
      options: options,
    );
  }
}
