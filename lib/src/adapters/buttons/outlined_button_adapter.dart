import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_button.dart';

/// Adapts [OutlinedButton] to Liquid Glass styling with specular border emphasis.
class OutlinedButtonLiquidAdapter extends LiquidGlassAdapter<OutlinedButton> {
  const OutlinedButtonLiquidAdapter();

  @override
  Widget build(OutlinedButton widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final side = widget.style?.side?.resolve({});
        final primary = theme.colorScheme.primary;

        final mergedOptions = options.copyWith(
          borderGradient:
              options.borderGradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  side?.color ?? primary.withValues(alpha: 0.70),
                  (side?.color ?? primary).withValues(alpha: 0.20),
                ],
              ),
          borderWidth: side?.width ?? options.borderWidth ?? 1.5,
          opacity: options.opacity ?? 0.40,
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
          child: widget.child,
        );
      },
    );
  }
}
