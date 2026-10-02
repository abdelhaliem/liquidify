import 'package:flutter/widgets.dart';
import '../adapters/bootstrap_adapters.dart';
import 'liquid_glass_adapter.dart';

/// Centralized registry for mapping Flutter widgets to their respective
/// [LiquidGlassAdapter] implementations.
class LiquidGlassRegistry {
  LiquidGlassRegistry._();

  static final LiquidGlassRegistry _instance = LiquidGlassRegistry._();

  /// The singleton instance of [LiquidGlassRegistry].
  static LiquidGlassRegistry get instance => _instance;

  final Map<Type, LiquidGlassAdapter<dynamic>> _adapters = {};
  bool _initialized = false;

  /// Optional initializer callback to register default built-in adapters.
  static void Function(LiquidGlassRegistry registry)? defaultBootstrap;

  void _ensureInitialized() {
    if (!_initialized) {
      _initialized = true;
      bootstrapLiquidGlassAdapters(this);
    }
  }

  /// Registers an adapter for widget type [T].
  ///
  /// ```dart
  /// LiquidGlassRegistry.register<BottomNavigationBar>(
  ///   BottomNavigationBarLiquidAdapter(),
  /// );
  /// ```
  static void register<T extends Widget>(LiquidGlassAdapter<T> adapter) {
    _instance._ensureInitialized();
    _instance._adapters[T] = adapter;
  }

  /// Retrieves an adapter explicitly registered for type [T].
  static LiquidGlassAdapter<T>? get<T extends Widget>() {
    _instance._ensureInitialized();
    final adapter = _instance._adapters[T];
    if (adapter != null) {
      return adapter as LiquidGlassAdapter<T>;
    }
    return null;
  }

  /// Finds the best matching adapter for the given [widget] instance.
  ///
  /// First attempts an exact `runtimeType` match, then falls back to `widget is T`.
  static LiquidGlassAdapter<dynamic>? find(Widget widget) {
    _instance._ensureInitialized();

    // 1. Direct runtime type match
    final direct = _instance._adapters[widget.runtimeType];
    if (direct != null) return direct;

    // 2. Polymorphic match
    for (final adapter in _instance._adapters.values) {
      try {
        if (adapter.canHandle(widget)) {
          return adapter;
        }
      } catch (_) {}
    }

    return null;
  }

  /// Whether an adapter is registered for type [T].
  static bool has<T extends Widget>() {
    _instance._ensureInitialized();
    return _instance._adapters.containsKey(T);
  }

  /// Removes the adapter registered for type [T].
  static void unregister<T extends Widget>() {
    _instance._adapters.remove(T);
  }

  /// Clears all registered adapters (useful for testing).
  @visibleForTesting
  static void clear() {
    _instance._adapters.clear();
    _instance._initialized = false;
  }
}
