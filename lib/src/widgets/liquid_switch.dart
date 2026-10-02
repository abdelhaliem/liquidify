import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/liquid_glass_options.dart';
import '../native/native_liquid_glass_switch.dart';
import 'liquid_glass_container.dart';

/// An Apple-style frosted Liquid Glass toggle switch.
///
/// **Hybrid Rendering:**
/// - On **iOS**: Uses native `UISwitch` via Platform Views.
/// - On **other platforms**: Uses a custom Flutter toggle with
///   `LiquidGlassContainer` for the track.
class LiquidSwitch extends StatefulWidget {
  /// Whether the switch is on or off.
  final bool value;

  /// Called when the user toggles the switch.
  final ValueChanged<bool>? onChanged;

  /// Custom Liquid Glass options.
  final LiquidGlassOptions? options;

  /// Active track tint color.
  final Color? activeColor;

  /// Inactive track tint color.
  final Color? inactiveTrackColor;

  /// Thumb color.
  final Color? thumbColor;

  /// Focus node for keyboard accessibility.
  final FocusNode? focusNode;

  /// Whether this switch should autofocus.
  final bool autofocus;

  /// Creates a [LiquidSwitch].
  const LiquidSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.options,
    this.activeColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<LiquidSwitch> createState() => _LiquidSwitchState();
}

class _LiquidSwitchState extends State<LiquidSwitch> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onChanged != null;

  @override
  Widget build(BuildContext context) {
    // Use native UISwitch on iOS
    if (!kIsWeb && Platform.isIOS) {
      return NativeLiquidGlassSwitch(
        value: widget.value,
        onChanged: widget.onChanged,
        activeColor: widget.activeColor,
        fallback: _buildFlutterSwitch(context),
      );
    }
    return _buildFlutterSwitch(context);
  }

  Widget _buildFlutterSwitch(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveActiveColor =
        widget.activeColor ?? const Color(0xFF34C759); // Apple iOS green
    final effectiveInactiveColor =
        widget.inactiveTrackColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.08));

    const trackWidth = 52.0;
    const trackHeight = 31.0;
    const thumbSize = 27.0;
    final maxOffset = trackWidth - thumbSize - 4.0;

    final trackTint = widget.value
        ? effectiveActiveColor.withValues(alpha: 0.65)
        : effectiveInactiveColor;

    final trackOptions = (widget.options ?? const LiquidGlassOptions())
        .copyWith(
          borderRadius: BorderRadius.circular(trackHeight / 2.0),
          tint: trackTint,
          blur: widget.options?.blur ?? 16.0,
          opacity: _isEnabled ? 0.85 : 0.40,
        );

    return Semantics(
      toggled: widget.value,
      enabled: _isEnabled,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _isEnabled
              ? (_) => setState(() => _isPressed = true)
              : null,
          onTapUp: _isEnabled
              ? (_) {
                  setState(() => _isPressed = false);
                  widget.onChanged?.call(!widget.value);
                }
              : null,
          onTapCancel: _isEnabled
              ? () => setState(() => _isPressed = false)
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            width: trackWidth,
            height: trackHeight,
            child: LiquidGlassContainer(
              options: trackOptions,
              borderRadius: BorderRadius.circular(trackHeight / 2.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    left: widget.value ? maxOffset : 2.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: _isPressed ? thumbSize + 4.0 : thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: widget.thumbColor ?? Colors.white,
                        borderRadius: BorderRadius.circular(thumbSize / 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.20),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
