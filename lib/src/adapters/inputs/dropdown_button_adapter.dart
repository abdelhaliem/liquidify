import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [DropdownButton] into an Apple-style Liquid Glass dropdown button.
class DropdownButtonLiquidAdapter<T>
    extends LiquidGlassAdapter<DropdownButton<T>> {
  const DropdownButtonLiquidAdapter();

  @override
  Widget build(DropdownButton<T> widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final radius = options.borderRadius ?? BorderRadius.circular(14.0);

        return LiquidGlassContainer(
          options: options.copyWith(borderRadius: radius),
          borderRadius: radius,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: DropdownButtonHideUnderline(child: widget),
        );
      },
    );
  }
}
