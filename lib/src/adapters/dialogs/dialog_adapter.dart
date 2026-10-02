import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts generic [Dialog] to a frosted Liquid Glass dialog.
class DialogLiquidAdapter extends LiquidGlassAdapter<Dialog> {
  const DialogLiquidAdapter();

  @override
  Widget build(Dialog widget, LiquidGlassOptions options) {
    final radius = options.borderRadius ?? BorderRadius.circular(22.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: widget.insetPadding,
      clipBehavior: Clip.none,
      alignment: widget.alignment,
      child: LiquidGlassContainer(
        options: options.copyWith(
          borderRadius: radius,
          blur: options.blur ?? 28.0,
          opacity: options.opacity ?? 0.82,
        ),
        borderRadius: radius,
        child: widget.child,
      ),
    );
  }
}
