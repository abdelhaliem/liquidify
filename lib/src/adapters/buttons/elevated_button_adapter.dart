import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_button.dart';

/// Adapts [ElevatedButton] to Liquid Glass styling.
class ElevatedButtonLiquidAdapter extends LiquidGlassAdapter<ElevatedButton> {
  const ElevatedButtonLiquidAdapter();

  @override
  Widget build(ElevatedButton widget, LiquidGlassOptions options) {
    Color? tint = options.tint;
    if (tint == null && widget.style?.backgroundColor != null) {
      tint = widget.style!.backgroundColor!.resolve({});
    }

    return LiquidButton(
      key: widget.key,
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      options: options,
      tint: tint,
      child: widget.child,
    );
  }
}
