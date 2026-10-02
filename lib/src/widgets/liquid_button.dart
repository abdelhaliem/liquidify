import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/liquid_glass_options.dart';
import '../native/native_liquid_glass_button.dart';
import 'liquid_glass_container.dart';

/// An interactive Liquid Glass button that preserves standard button callbacks,
/// semantics, and states with frosted glass aesthetics.
class LiquidButton extends StatefulWidget {
  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// Called when a pointer enters or exits the button response area.
  final ValueChanged<bool>? onHover;

  /// Called when the focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether this button should autofocus.
  final bool autofocus;

  /// Custom Liquid Glass options.
  final LiquidGlassOptions? options;

  /// The button's label or icon widget.
  final Widget? child;

  /// Optional custom padding.
  final EdgeInsetsGeometry? padding;

  /// Optional custom border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Optional background tint color.
  final Color? tint;

  /// Creates a [LiquidButton].
  const LiquidButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.options,
    this.child,
    this.padding,
    this.borderRadius,
    this.tint,
  });

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  bool get _isEnabled => widget.onPressed != null || widget.onLongPress != null;

  @override
  Widget build(BuildContext context) {
    // Use native UIButton on iOS for text-only buttons
    if (!kIsWeb && Platform.isIOS && widget.child is Text) {
      final textChild = widget.child! as Text;
      return NativeLiquidGlassButton(
        title: textChild.data ?? '',
        onPressed: widget.onPressed,
        cornerRadius: 12.0,
        fallback: _buildFlutterButton(context),
      );
    }

    return _buildFlutterButton(context);
  }

  Widget _buildFlutterButton(BuildContext context) {
    final effectiveRadius =
        widget.borderRadius ??
        widget.options?.borderRadius ??
        BorderRadius.circular(12.0);

    final isInteractive = widget.options?.interactive ?? true;

    Color? effectiveTint = widget.tint ?? widget.options?.tint;
    if (_isHovered && effectiveTint != null) {
      effectiveTint = effectiveTint.withValues(
        alpha: (effectiveTint.a * 1.25).clamp(0.0, 1.0),
      );
    }

    final buttonOptions = (widget.options ?? const LiquidGlassOptions())
        .copyWith(
          borderRadius: effectiveRadius,
          tint: effectiveTint,
          opacity: _isEnabled ? null : 0.40,
        );

    Widget result = LiquidGlassContainer(
      options: buttonOptions,
      borderRadius: effectiveRadius,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: DefaultTextStyle(
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
          child: IconTheme.merge(
            data: IconThemeData(
              color: Theme.of(context).colorScheme.onSurface,
              size: 20.0,
            ),
            child: widget.child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );

    if (isInteractive && _isEnabled) {
      result = AnimatedScale(
        scale: _isPressed ? 0.96 : (_isHovered ? 1.02 : 1.0),
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: result,
      );
    }

    return Semantics(
      button: true,
      enabled: _isEnabled,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: widget.onFocusChange,
        child: MouseRegion(
          cursor: _isEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) {
            setState(() => _isHovered = true);
            widget.onHover?.call(true);
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            widget.onHover?.call(false);
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _isEnabled
                ? (_) => setState(() => _isPressed = true)
                : null,
            onTapUp: _isEnabled
                ? (_) => setState(() => _isPressed = false)
                : null,
            onTapCancel: _isEnabled
                ? () => setState(() => _isPressed = false)
                : null,
            onTap: widget.onPressed,
            onLongPress: widget.onLongPress,
            child: result,
          ),
        ),
      ),
    );
  }
}
