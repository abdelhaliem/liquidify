// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';
import 'radio_adapter.dart';

/// Adapts [RadioListTile] to a Liquid Glass list tile.
class RadioListTileLiquidAdapter<T>
    extends LiquidGlassAdapter<RadioListTile<T>> {
  const RadioListTileLiquidAdapter();

  @override
  Widget build(RadioListTile<T> widget, LiquidGlassOptions options) {
    final radius = options.borderRadius ?? BorderRadius.circular(14.0);

    final liquidRadio = RadioLiquidAdapter<T>().build(
      Radio<T>(
        value: widget.value,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
        activeColor: widget.activeColor,
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
          liquidRadio,
        ],
      ),
    );
  }
}
