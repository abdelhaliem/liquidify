// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_switch.dart';

/// Adapts [Switch] to the Liquid Glass toggle switch.
class SwitchLiquidAdapter extends LiquidGlassAdapter<Switch> {
  const SwitchLiquidAdapter();

  @override
  Widget build(Switch widget, LiquidGlassOptions options) {
    Color? thumbColor = widget.thumbColor?.resolve({});

    return LiquidSwitch(
      key: widget.key,
      value: widget.value,
      onChanged: widget.onChanged,
      activeColor: widget.activeColor,
      inactiveTrackColor: widget.inactiveTrackColor,
      thumbColor: thumbColor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      options: options,
    );
  }
}
