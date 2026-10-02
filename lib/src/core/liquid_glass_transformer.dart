import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'liquid_glass_adapter.dart';
import 'liquid_glass_options.dart';
import 'liquid_glass_platform.dart';
import 'liquid_glass_registry.dart';
import 'liquid_glass_theme.dart';

/// A widget wrapper that dynamically resolves ambient options, checks platform support,
/// and delegates to the appropriate [LiquidGlassAdapter].
class LiquidGlassTransformer<T extends Widget> extends StatelessWidget {
  /// The source widget to adapt.
  final T widget;

  /// Optional custom options overriding the ambient [LiquidGlassTheme].
  final LiquidGlassOptions? options;

  /// Creates a [LiquidGlassTransformer].
  const LiquidGlassTransformer({super.key, required this.widget, this.options});

  @override
  Widget build(BuildContext context) {
    if (options != null && !options!.enabled) {
      return widget;
    }

    final resolvedOptions = LiquidGlassTheme.resolve(
      context,
      overrides: options,
    );

    if (!resolvedOptions.enabled) {
      return widget;
    }

    // Platform validation
    final isSupported = LiquidGlassPlatform.isSupported(
      context,
      force: resolvedOptions.force,
    );
    if (!isSupported) {
      return widget;
    }

    // Adapter resolution
    final adapter =
        LiquidGlassRegistry.get<T>() ?? LiquidGlassRegistry.find(widget);

    if (adapter == null) {
      if (kDebugMode) {
        debugPrint(
          'LiquidGlass: No adapter registered for ${widget.runtimeType}. Returning original widget.',
        );
      }
      return widget;
    }

    try {
      return adapter.build(widget, resolvedOptions);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'LiquidGlass: Error adapting ${widget.runtimeType}: $error\n$stackTrace',
        );
      }
      return widget;
    }
  }
}
