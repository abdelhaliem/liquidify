import 'package:flutter/widgets.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Generic fallback adapter that wraps any [Widget] in a [LiquidGlassContainer].
class GenericWidgetLiquidAdapter extends LiquidGlassAdapter<Widget> {
  const GenericWidgetLiquidAdapter();

  @override
  Widget build(Widget widget, LiquidGlassOptions options) {
    return LiquidGlassContainer(options: options, child: widget);
  }
}
