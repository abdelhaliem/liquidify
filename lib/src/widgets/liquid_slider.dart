import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/liquid_glass_options.dart';
import '../native/native_liquid_glass_slider.dart';
import 'liquid_glass_container.dart';

/// An Apple-style frosted Liquid Glass slider.
///
/// **Hybrid Rendering:**
/// - On **iOS**: Uses native `UISlider` via Platform Views.
/// - On **other platforms**: Uses a custom Flutter slider with
///   `LiquidGlassContainer` for the track and thumb.
class LiquidSlider extends StatefulWidget {
  /// The current slider value.
  final double value;

  /// Called when the value changes.
  final ValueChanged<double>? onChanged;

  /// Called when user starts interacting.
  final ValueChanged<double>? onChangeStart;

  /// Called when user finishes interacting.
  final ValueChanged<double>? onChangeEnd;

  /// Minimum value. Defaults to 0.0.
  final double min;

  /// Maximum value. Defaults to 1.0.
  final double max;

  /// Number of discrete divisions.
  final int? divisions;

  /// Active track tint.
  final Color? activeColor;

  /// Inactive track tint.
  final Color? inactiveColor;

  /// Custom Liquid Glass options.
  final LiquidGlassOptions? options;

  /// Focus node for accessibility.
  final FocusNode? focusNode;

  /// Whether this slider should autofocus.
  final bool autofocus;

  /// Creates a [LiquidSlider].
  const LiquidSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.options,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<LiquidSlider> createState() => _LiquidSliderState();
}

class _LiquidSliderState extends State<LiquidSlider> {
  bool _isDragging = false;

  bool get _isEnabled => widget.onChanged != null;

  bool get _isIOSPlatform {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  double get _fraction {
    final range = widget.max - widget.min;
    if (range <= 0) return 0.0;
    return ((widget.value - widget.min) / range).clamp(0.0, 1.0);
  }

  void _handleDrag(double localDx, double width) {
    if (!_isEnabled || width <= 0) return;
    const thumbRadius = 12.0;
    final usableWidth = width - (thumbRadius * 2);
    final clampedX = (localDx - thumbRadius).clamp(0.0, usableWidth);
    var newFraction = clampedX / usableWidth;

    if (widget.divisions != null && widget.divisions! > 0) {
      newFraction =
          (newFraction * widget.divisions!).round() / widget.divisions!;
    }

    final newValue = widget.min + newFraction * (widget.max - widget.min);
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    // Use native UISlider on iOS
    if (_isIOSPlatform) {
      return NativeLiquidGlassSlider(
        value: widget.value,
        onChanged: widget.onChanged,
        min: widget.min,
        max: widget.max,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        fallback: _buildFlutterSlider(context),
      );
    }

    return _buildFlutterSlider(context);
  }

  Widget _buildFlutterSlider(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primary = widget.activeColor ?? theme.colorScheme.primary;
    final inactive =
        widget.inactiveColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.08));

    const height = 28.0;
    const thumbRadius = 12.0;
    final trackRadius = BorderRadius.circular(height / 2.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 200.0;
        final fraction = _fraction;
        final usableWidth = totalWidth - (thumbRadius * 2);
        final thumbOffset = thumbRadius + (fraction * usableWidth);

        return Semantics(
          slider: true,
          value: widget.value.toStringAsFixed(1),
          enabled: _isEnabled,
          child: Focus(
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: _isEnabled
                  ? (details) {
                      setState(() => _isDragging = true);
                      widget.onChangeStart?.call(widget.value);
                      _handleDrag(details.localPosition.dx, totalWidth);
                    }
                  : null,
              onHorizontalDragUpdate: _isEnabled
                  ? (details) =>
                        _handleDrag(details.localPosition.dx, totalWidth)
                  : null,
              onHorizontalDragEnd: _isEnabled
                  ? (_) {
                      setState(() => _isDragging = false);
                      widget.onChangeEnd?.call(widget.value);
                    }
                  : null,
              onTapDown: _isEnabled
                  ? (details) {
                      setState(() => _isDragging = true);
                      widget.onChangeStart?.call(widget.value);
                      _handleDrag(details.localPosition.dx, totalWidth);
                    }
                  : null,
              onTapUp: _isEnabled
                  ? (_) {
                      setState(() => _isDragging = false);
                      widget.onChangeEnd?.call(widget.value);
                    }
                  : null,
              child: SizedBox(
                height: height,
                width: totalWidth,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    LiquidGlassContainer(
                      useNative: false,
                      options: (widget.options ?? const LiquidGlassOptions())
                          .copyWith(
                            borderRadius: trackRadius,
                            tint: inactive,
                            blur: widget.options?.blur ?? 14.0,
                            opacity: _isEnabled ? 0.80 : 0.40,
                          ),
                      borderRadius: trackRadius,
                      height: height,
                      width: totalWidth,
                      child: ClipRRect(
                        borderRadius: trackRadius,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: _isDragging
                                ? Duration.zero
                                : const Duration(milliseconds: 100),
                            width: thumbOffset,
                            height: height,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primary.withValues(alpha: 0.65),
                                  primary.withValues(alpha: 0.85),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: thumbOffset - thumbRadius,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        width: _isDragging
                            ? thumbRadius * 2 + 4
                            : thumbRadius * 2,
                        height: _isDragging
                            ? thumbRadius * 2 + 4
                            : thumbRadius * 2,
                        child: LiquidGlassContainer(
                          useNative: false,
                          options: LiquidGlassOptions(
                            blur: 16.0,
                            opacity: 0.90,
                            tint: Colors.white,
                            borderRadius: BorderRadius.circular(
                              thumbRadius + 2,
                            ),
                            borderWidth: 1.5,
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 6.0,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(thumbRadius + 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
