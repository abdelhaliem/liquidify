import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_button.dart';

/// Adapts [IconButton] to a circular or squircle Liquid Glass button.
class IconButtonLiquidAdapter extends LiquidGlassAdapter<IconButton> {
  const IconButtonLiquidAdapter();

  @override
  Widget build(IconButton widget, LiquidGlassOptions options) {
    final effectiveRadius = options.borderRadius ?? BorderRadius.circular(22.0);
    final isEnabled = widget.onPressed != null;

    final iconWidget = IconTheme.merge(
      data: IconThemeData(
        color: isEnabled ? widget.color : widget.disabledColor,
        size: widget.iconSize ?? 22.0,
      ),
      child: widget.icon,
    );

    Widget result = LiquidButton(
      key: widget.key,
      onPressed: widget.onPressed,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      options: options.copyWith(borderRadius: effectiveRadius),
      padding: widget.padding ?? const EdgeInsets.all(10.0),
      borderRadius: effectiveRadius,
      child: iconWidget,
    );

    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }

    return result;
  }
}
