import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Picker mode for [NativeLiquidGlassDatePicker].
enum LiquidDatePickerMode {
  /// Date only (year, month, day).
  date,

  /// Time only (hour, minute).
  time,

  /// Date and time combined.
  dateAndTime,

  /// Countdown timer.
  countDownTimer,
}

/// A native iOS `UIDatePicker` with Liquid Glass background.
///
/// On iOS 26+, the picker inherits Liquid Glass material for the
/// authentic Apple glass look. Supports date, time, dateAndTime,
/// and countdown timer modes.
class NativeLiquidGlassDatePicker extends StatefulWidget {
  /// The picker mode.
  final LiquidDatePickerMode mode;

  /// Initial date.
  final DateTime? initialDate;

  /// Minimum selectable date.
  final DateTime? minimumDate;

  /// Maximum selectable date.
  final DateTime? maximumDate;

  /// Corner radius of the glass container.
  final double cornerRadius;

  /// Height of the picker view.
  final double height;

  /// Called when the selected date changes.
  final ValueChanged<DateTime>? onChanged;

  /// Widget to show on non-iOS platforms.
  final Widget? fallback;

  /// Creates a [NativeLiquidGlassDatePicker].
  const NativeLiquidGlassDatePicker({
    super.key,
    this.mode = LiquidDatePickerMode.dateAndTime,
    this.initialDate,
    this.minimumDate,
    this.maximumDate,
    this.cornerRadius = 16.0,
    this.height = 340.0,
    this.onChanged,
    this.fallback,
  });

  @override
  State<NativeLiquidGlassDatePicker> createState() =>
      _NativeLiquidGlassDatePickerState();
}

class _NativeLiquidGlassDatePickerState
    extends State<NativeLiquidGlassDatePicker> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isIOS) {
      return widget.fallback ?? const SizedBox.shrink();
    }

    final modeString = switch (widget.mode) {
      LiquidDatePickerMode.date => 'date',
      LiquidDatePickerMode.time => 'time',
      LiquidDatePickerMode.countDownTimer => 'countDownTimer',
      LiquidDatePickerMode.dateAndTime => 'dateAndTime',
    };

    return SizedBox(
      height: widget.height,
      child: UiKitView(
        viewType: 'liquidify/date_picker',
        creationParams: {
          'mode': modeString,
          'cornerRadius': widget.cornerRadius,
          'initialDate':
              widget.initialDate?.millisecondsSinceEpoch.toDouble(),
          'minimumDate':
              widget.minimumDate?.millisecondsSinceEpoch.toDouble(),
          'maximumDate':
              widget.maximumDate?.millisecondsSinceEpoch.toDouble(),
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onCreated,
      ),
    );
  }

  void _onCreated(int viewId) {
    _channel = MethodChannel('liquidify/date_picker_$viewId');
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onChanged') {
        final timestamp = call.arguments as double;
        final date = DateTime.fromMillisecondsSinceEpoch(
          timestamp.toInt(),
        );
        widget.onChanged?.call(date);
      }
    });
  }
}
