import 'package:flutter/widgets.dart';
import 'liquid_glass_options.dart';

/// Interface for widget-specific Liquid Glass adapters.
///
/// An adapter receives a strongly typed Flutter widget instance along with
/// resolved [LiquidGlassOptions] and returns a Liquid Glass-styled equivalent
/// that preserves all original callbacks, properties, and behaviors.
abstract class LiquidGlassAdapter<T extends Widget> {
  const LiquidGlassAdapter();

  /// Whether this adapter can handle the specified [widget].
  bool canHandle(Widget widget) => widget is T;

  /// Builds the Liquid Glass representation for [widget].
  Widget build(T widget, LiquidGlassOptions options);
}
