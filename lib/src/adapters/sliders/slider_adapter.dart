import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_slider.dart';

/// Adapts [Slider] to a sleek Apple-style Liquid Glass slider.
class SliderLiquidAdapter extends LiquidGlassAdapter<Slider> {
  const SliderLiquidAdapter();

  @override
  Widget build(Slider widget, LiquidGlassOptions options) {
    return LiquidSlider(
      key: widget.key,
      value: widget.value,
      onChanged: widget.onChanged,
      onChangeStart: widget.onChangeStart,
      onChangeEnd: widget.onChangeEnd,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      options: options,
    );
  }
}
