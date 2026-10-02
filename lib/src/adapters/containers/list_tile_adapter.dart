import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [ListTile] into a sleek Liquid Glass row item.
class ListTileLiquidAdapter extends LiquidGlassAdapter<ListTile> {
  const ListTileLiquidAdapter();

  @override
  Widget build(ListTile widget, LiquidGlassOptions options) {
    final radius = options.borderRadius ?? BorderRadius.circular(14.0);

    return LiquidGlassContainer(
      options: options.copyWith(
        borderRadius: radius,
        tint: widget.selected
            ? (options.tint ?? Colors.blue.withValues(alpha: 0.15))
            : (options.tint ?? widget.tileColor),
      ),
      borderRadius: radius,
      child: Material(color: Colors.transparent, child: widget),
    );
  }
}
