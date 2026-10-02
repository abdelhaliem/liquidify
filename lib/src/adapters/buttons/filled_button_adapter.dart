import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_button.dart';

/// Adapts [FilledButton] to Liquid Glass styling with vibrant translucent tinting.
class FilledButtonLiquidAdapter extends LiquidGlassAdapter<FilledButton> {
  const FilledButtonLiquidAdapter();

  @override
  Widget build(FilledButton widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        Color? tint =
            options.tint ??
            widget.style?.backgroundColor?.resolve({}) ??
            theme.colorScheme.primary.withValues(alpha: 0.35);

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
      },
    );
  }
}
