import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Data class for a picker selection change event.
@immutable
class LiquidPickerChange {
  /// Column index.
  final int component;

  /// Row index within the column.
  final int row;

  /// Selected value string.
  final String value;

  /// Creates a [LiquidPickerChange].
  const LiquidPickerChange({
    required this.component,
    required this.row,
    required this.value,
  });
}

/// A native iOS `UIPickerView` (wheel selector) with glass background.
///
/// On iOS 26+, the picker container uses `UIGlassEffect` for the
/// authentic Apple glass look. Supports single or multi-column data.
class NativeLiquidGlassPicker extends StatefulWidget {
  /// Column data — each inner list is one column of items.
  final List<List<String>> columns;

  /// Initial selected row per column.
  final List<int>? initialSelections;

  /// Corner radius of the glass container.
  final double cornerRadius;

  /// Height of the picker view.
  final double height;

  /// Called when a selection changes.
  final ValueChanged<LiquidPickerChange>? onChanged;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassPicker].
  const NativeLiquidGlassPicker({
    super.key,
    required this.columns,
    this.initialSelections,
    this.cornerRadius = 16.0,
    this.height = 216.0,
    this.onChanged,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassPicker> createState() =>
      _NativeLiquidGlassPickerState();
}

class _NativeLiquidGlassPickerState
    extends State<NativeLiquidGlassPicker> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/picker',
        creationParams: {
          'columns': widget.columns,
          'initialSelections': widget.initialSelections ?? [],
          'cornerRadius': widget.cornerRadius,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/picker_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onChanged') {
        final args = call.arguments as Map;
        widget.onChanged?.call(
          LiquidPickerChange(
            component: args['component'] as int,
            row: args['row'] as int,
            value: args['value'] as String,
          ),
        );
      }
    });
  }
}
