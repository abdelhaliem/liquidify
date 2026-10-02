import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_button.dart';

/// Adapts [TextButton] to an ultra-translucent Liquid Glass styling.
class TextButtonLiquidAdapter extends LiquidGlassAdapter<TextButton> {
  const TextButtonLiquidAdapter();

  @override
  Widget build(TextButton widget, LiquidGlassOptions options) {
    final mergedOptions = options.copyWith(
      opacity: options.opacity ?? 0.20,
      blur: options.blur ?? 10.0,
      shadows: options.shadows ?? const [],
    );

    return LiquidButton(
      key: widget.key,
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      options: mergedOptions,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: widget.child,
    );
  }
}
