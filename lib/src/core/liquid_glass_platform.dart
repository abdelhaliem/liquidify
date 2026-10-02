import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Platform detection and capability utilities for Liquid Glass effects.
class LiquidGlassPlatform {
  LiquidGlassPlatform._();

  @visibleForTesting
  static TargetPlatform? overridePlatform;

  /// Returns the current active target platform, respecting any test overrides.
  static TargetPlatform get currentPlatform =>
      overridePlatform ?? defaultTargetPlatform;

  /// Whether the current platform natively supports Apple-style Liquid Glass UI.
  ///
  /// By default, iOS and macOS are considered native Liquid Glass platforms.
  static bool get isApplePlatform {
    final platform = currentPlatform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }

  /// Determines whether the Liquid Glass effect should be rendered in the current context.
  ///
  /// Returns `true` if:
  /// 1. [force] is `true`, OR
  /// 2. The host device is iOS or macOS.
  ///
  /// On Android, Web, Windows, and Linux, returns `false` by default unless [force] is `true`.
  static bool isSupported(BuildContext context, {bool force = false}) {
    if (force) return true;
    return isApplePlatform;
  }

  /// Resets any test platform overrides.
  @visibleForTesting
  static void reset() {
    overridePlatform = null;
  }
}
