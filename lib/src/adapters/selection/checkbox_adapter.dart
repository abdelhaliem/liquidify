import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [Checkbox] to a frosted Liquid Glass checkbox.
class CheckboxLiquidAdapter extends LiquidGlassAdapter<Checkbox> {
  const CheckboxLiquidAdapter();

  @override
  Widget build(Checkbox widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isChecked = widget.value == true;
        final isIndeterminate = widget.tristate && widget.value == null;
        final isEnabled = widget.onChanged != null;

        final activeColor = widget.activeColor ?? theme.colorScheme.primary;
        final checkColor = widget.checkColor ?? Colors.white;

        final radius = options.borderRadius ?? BorderRadius.circular(6.0);

        final mergedOptions = options.copyWith(
          borderRadius: radius,
          tint: isChecked || isIndeterminate
              ? activeColor.withValues(alpha: 0.70)
              : null,
          opacity: isEnabled ? null : 0.40,
        );

        Widget icon = const SizedBox.shrink();
        if (isChecked) {
          icon = Icon(Icons.check, size: 16.0, color: checkColor);
        } else if (isIndeterminate) {
          icon = Container(width: 10.0, height: 2.0, color: checkColor);
        }

        return Semantics(
          checked: isChecked,
          enabled: isEnabled,
          child: Focus(
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isEnabled
                  ? () {
                      if (widget.tristate) {
                        if (widget.value == false) {
                          widget.onChanged?.call(true);
                        } else if (widget.value == true) {
                          widget.onChanged?.call(null);
                        } else {
                          widget.onChanged?.call(false);
                        }
                      } else {
                        widget.onChanged?.call(!isChecked);
                      }
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22.0,
                height: 22.0,
                child: LiquidGlassContainer(
                  options: mergedOptions,
                  borderRadius: radius,
                  child: Center(child: icon),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
