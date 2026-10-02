import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_button.dart';

/// Adapts [FloatingActionButton] to a floating Liquid Glass action button.
class FloatingActionButtonLiquidAdapter
    extends LiquidGlassAdapter<FloatingActionButton> {
  const FloatingActionButtonLiquidAdapter();

  @override
  Widget build(FloatingActionButton widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final bg = widget.backgroundColor ?? theme.colorScheme.primary;
        final fg = widget.foregroundColor ?? theme.colorScheme.onPrimary;

        final radius = options.borderRadius ?? BorderRadius.circular(16.0);

        final mergedOptions = options.copyWith(
          tint: options.tint ?? bg.withValues(alpha: 0.35),
          borderRadius: radius,
          shadows:
              options.shadows ??
              [
                BoxShadow(
                  color: (options.tint ?? bg).withValues(alpha: 0.30),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
        );

        Widget result = LiquidButton(
          key: widget.key,
          onPressed: widget.onPressed,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          options: mergedOptions,
          borderRadius: radius,
          padding: widget.isExtended
              ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0)
              : const EdgeInsets.all(16.0),
          child: DefaultTextStyle(
            style: TextStyle(color: fg, fontWeight: FontWeight.w600),
            child: IconTheme.merge(
              data: IconThemeData(color: fg),
              child: widget.child ?? const SizedBox.shrink(),
            ),
          ),
        );

        if (widget.tooltip != null) {
          result = Tooltip(message: widget.tooltip!, child: result);
        }

        return result;
      },
    );
  }
}
