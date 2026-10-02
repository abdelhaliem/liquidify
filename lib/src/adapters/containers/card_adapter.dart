import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [Card] to an Apple-style frosted Liquid Glass card.
class CardLiquidAdapter extends LiquidGlassAdapter<Card> {
  const CardLiquidAdapter();

  @override
  Widget build(Card widget, LiquidGlassOptions options) {
    BorderRadiusGeometry? shapeRadius;
    if (widget.shape is RoundedRectangleBorder) {
      shapeRadius = (widget.shape as RoundedRectangleBorder).borderRadius;
    }

    final radius =
        options.borderRadius ?? shapeRadius ?? BorderRadius.circular(16.0);

    return LiquidGlassContainer(
      options: options.copyWith(
        borderRadius: radius,
        margin: widget.margin ?? options.margin,
        tint: options.tint ?? widget.color,
      ),
      borderRadius: radius,
      clipBehavior: widget.clipBehavior ?? Clip.antiAlias,
      child: widget.child,
    );
  }
}
