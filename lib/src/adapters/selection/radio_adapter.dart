// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [Radio] to a circular Liquid Glass radio button.
class RadioLiquidAdapter<T> extends LiquidGlassAdapter<Radio<T>> {
  const RadioLiquidAdapter();

  @override
  Widget build(Radio<T> widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isSelected = widget.value == widget.groupValue;
        final isEnabled = widget.onChanged != null;

        final activeColor = widget.activeColor ?? theme.colorScheme.primary;
        final radius = BorderRadius.circular(11.0);

        final mergedOptions = options.copyWith(
          borderRadius: radius,
          tint: isSelected ? activeColor.withValues(alpha: 0.35) : null,
          opacity: isEnabled ? null : 0.40,
        );

        return Semantics(
          checked: isSelected,
          inMutuallyExclusiveGroup: true,
          enabled: isEnabled,
          child: Focus(
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isEnabled
                  ? () => widget.onChanged?.call(widget.value)
                  : null,
              child: SizedBox(
                width: 22.0,
                height: 22.0,
                child: LiquidGlassContainer(
                  options: mergedOptions,
                  borderRadius: radius,
                  child: Center(
                    child: AnimatedScale(
                      scale: isSelected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: activeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
