import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [Container] to a Liquid Glass container.
class ContainerLiquidAdapter extends LiquidGlassAdapter<Container> {
  const ContainerLiquidAdapter();

  @override
  Widget build(Container widget, LiquidGlassOptions options) {
    return LiquidGlassContainer(
      options: options,
      borderRadius: options.borderRadius,
      padding: widget.padding,
      margin: widget.margin,
      alignment: widget.alignment,
      constraints: widget.constraints,
      child: widget.child,
    );
  }
}
