import 'package:flutter/services.dart';

/// Communicates with the native iOS/macOS plugin to query platform
/// capabilities related to Liquid Glass rendering.
class LiquidifyPlatformChannel {
  LiquidifyPlatformChannel._();

  static const _channel = MethodChannel('liquidify/platform');

  static bool? _cachedSupport;

  /// Returns `true` if the current device supports native Apple
  /// Liquid Glass rendering (iOS 26+ with `UIGlassEffect`).
  ///
  /// The result is cached after the first query to avoid repeated
  /// platform channel calls.
  static Future<bool> supportsNativeLiquidGlass() async {
    if (_cachedSupport != null) return _cachedSupport!;
    try {
      final result = await _channel.invokeMethod<bool>(
        'supportsNativeLiquidGlass',
      );
      _cachedSupport = result ?? false;
      return _cachedSupport!;
    } on PlatformException {
      _cachedSupport = false;
      return false;
    } on MissingPluginException {
      _cachedSupport = false;
      return false;
    }
  }

  /// Returns the native platform version string (e.g. "iOS 26.0").
  static Future<String?> getPlatformVersion() async {
    try {
      return await _channel.invokeMethod<String>('getPlatformVersion');
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  /// Resets the cached support value. Useful for testing.
  static void resetCache() {
    _cachedSupport = null;
  }
}
