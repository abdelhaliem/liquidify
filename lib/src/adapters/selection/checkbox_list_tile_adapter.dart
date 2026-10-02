import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';
import 'checkbox_adapter.dart';

/// Adapts [CheckboxListTile] to a Liquid Glass list tile.
class CheckboxListTileLiquidAdapter
    extends LiquidGlassAdapter<CheckboxListTile> {
  const CheckboxListTileLiquidAdapter();

  @override
  Widget build(CheckboxListTile widget, LiquidGlassOptions options) {
    final radius = options.borderRadius ?? BorderRadius.circular(14.0);

    final liquidCheckbox = const CheckboxLiquidAdapter().build(
      Checkbox(
        value: widget.value,
        tristate: widget.tristate,
        onChanged: widget.onChanged,
        activeColor: widget.activeColor,
        checkColor: widget.checkColor,
        autofocus: widget.autofocus,
      ),
      options,
    );

    return LiquidGlassContainer(
      options: options.copyWith(borderRadius: radius),
      borderRadius: radius,
      padding:
          widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          if (widget.secondary != null) ...[
            widget.secondary!,
            const SizedBox(width: 14.0),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null) widget.title!,
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 2.0),
                  widget.subtitle!,
                ],
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          liquidCheckbox,
        ],
      ),
    );
  }
}
