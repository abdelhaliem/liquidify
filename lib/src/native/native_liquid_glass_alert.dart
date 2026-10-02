import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Data class representing an action button in a native glass alert.
@immutable
class NativeAlertAction {
  /// The button label text.
  final String label;

  /// Whether the action is destructive (shown in red).
  final bool isDestructive;

  /// Whether the action is the default (shown in bold).
  final bool isDefault;

  /// Creates a [NativeAlertAction].
  const NativeAlertAction({
    required this.label,
    this.isDestructive = false,
    this.isDefault = false,
  });

  /// Converts to a map for platform channel encoding.
  Map<String, dynamic> toMap() => {
    'label': label,
    'isDestructive': isDestructive,
    'isDefault': isDefault,
  };
}

/// A native iOS alert view with Liquid Glass material.
///
/// On iOS 26+, the alert uses `UIGlassEffect` for the authentic
/// Apple glass look. On older versions, falls back to system blur.
class NativeLiquidGlassAlert extends StatefulWidget {
  /// Alert dialog title.
  final String? title;

  /// Alert dialog message body.
  final String? message;

  /// List of action buttons.
  final List<NativeAlertAction> actions;

  /// Corner radius of the alert container.
  final double cornerRadius;

  /// Height of the alert view.
  final double height;

  /// Called when an action button is tapped, with the action index.
  final ValueChanged<int>? onAction;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassAlert].
  const NativeLiquidGlassAlert({
    super.key,
    this.title,
    this.message,
    this.actions = const [],
    this.cornerRadius = 22.0,
    this.height = 180.0,
    this.onAction,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassAlert> createState() =>
      _NativeLiquidGlassAlertState();
}

class _NativeLiquidGlassAlertState
    extends State<NativeLiquidGlassAlert> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/alert',
        creationParams: {
          'title': widget.title ?? '',
          'message': widget.message ?? '',
          'actions':
              widget.actions.map((a) => a.toMap()).toList(),
          'cornerRadius': widget.cornerRadius,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/alert_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onAction') {
        widget.onAction?.call(call.arguments as int);
      }
    });
  }
}
