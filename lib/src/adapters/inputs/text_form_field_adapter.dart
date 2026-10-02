import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [TextFormField] to Liquid Glass styling while preserving form validation.
class TextFormFieldLiquidAdapter extends LiquidGlassAdapter<TextFormField> {
  const TextFormFieldLiquidAdapter();

  @override
  Widget build(TextFormField widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final radius = options.borderRadius ?? BorderRadius.circular(14.0);

        return LiquidGlassContainer(
          options: options.copyWith(borderRadius: radius),
          borderRadius: radius,
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
              ),
            ),
            child: widget,
          ),
        );
      },
    );
  }
}
