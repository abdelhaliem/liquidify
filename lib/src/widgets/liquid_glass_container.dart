import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/liquid_glass_options.dart';
import '../core/liquid_glass_theme.dart';
import '../utils/border_utils.dart';

/// A container that renders Apple-style Liquid Glass effects.
///
/// **Hybrid Rendering Strategy:**
/// - On **iOS 26+**: Uses native `UIVisualEffectView` via Platform
///   Views for authentic Apple system blur material. Uses a
///   two-pass measure-then-embed approach for intrinsically sized
///   widgets inside scrollable containers.
/// - On **other platforms**: Uses Flutter's `BackdropFilter` with
///   `ImageFilter.blur` as a cross-platform fallback.
class LiquidGlassContainer extends StatelessWidget {
  /// The widget below this container in the tree.
  final Widget? child;

  /// Custom options for the glass effect.
  final LiquidGlassOptions? options;

  /// Width constraint.
  final double? width;

  /// Height constraint.
  final double? height;

  /// Box constraints for sizing.
  final BoxConstraints? constraints;

  /// Internal padding.
  final EdgeInsetsGeometry? padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Alignment of the child within the container.
  final AlignmentGeometry? alignment;

  /// Border radius geometry for rounded corners.
  final BorderRadiusGeometry? borderRadius;

  /// Optional tap callback with touch response.
  final VoidCallback? onTap;

  /// Clip behavior. Defaults to [Clip.antiAlias].
  final Clip clipBehavior;

  /// If `true`, forces native rendering even when normally disabled.
  /// If `false`, forces Flutter fallback.
  /// If `null`, auto-detects based on platform and constraints.
  final bool? useNative;

  /// Creates a [LiquidGlassContainer].
  const LiquidGlassContainer({
    super.key,
    this.child,
    this.options,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment,
    this.borderRadius,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
    this.useNative,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = LiquidGlassTheme.resolve(context, overrides: options);

    final resolvedRadius =
        (borderRadius ?? resolved.borderRadius ?? BorderRadius.circular(16.0))
            .resolve(Directionality.of(context));

    // If useNative is explicitly false, skip native
    if (useNative == false) {
      return _buildFlutterFallback(context, resolved, resolvedRadius);
    }

    // On iOS, use the auto-measuring native approach
    if (_isIOSPlatform) {
      return _NativeMeasuredGlass(
        resolved: resolved,
        resolvedRadius: resolvedRadius,
        explicitWidth: width,
        explicitHeight: height,
        constraints: constraints,
        padding: padding,
        margin: margin,
        alignment: alignment,
        onTap: onTap,
        clipBehavior: clipBehavior,
        child: child,
        fallbackBuilder: () =>
            _buildFlutterFallback(context, resolved, resolvedRadius),
      );
    }

    return _buildFlutterFallback(context, resolved, resolvedRadius);
  }

  /// Whether the current runtime platform is iOS.
  static bool get _isIOSPlatform {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// Builds the container using Flutter's BackdropFilter.
  Widget _buildFlutterFallback(
    BuildContext context,
    LiquidGlassOptions resolved,
    BorderRadius resolvedRadius,
  ) {
    final effectivePadding = padding ?? resolved.padding;
    final effectiveMargin = margin ?? resolved.margin;
    final blur = resolved.blur ?? 18.0;

    Widget content = Container(
      width: width,
      height: height,
      constraints: constraints,
      alignment: alignment,
      padding: effectivePadding,
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: resolvedRadius,
          onTap: onTap,
          child: content,
        ),
      );
    }

    // Specular border overlay
    Widget glassSurface = content;
    if (resolved.border != null) {
      glassSurface = Container(
        decoration: BoxDecoration(
          borderRadius: resolvedRadius,
          border: resolved.border,
        ),
        child: glassSurface,
      );
    } else if (resolved.borderGradient != null &&
        (resolved.borderWidth ?? 1.0) > 0) {
      glassSurface = CustomPaint(
        foregroundPainter: LiquidSpecularBorderPainter(
          borderRadius: resolvedRadius,
          gradient: resolved.borderGradient!,
          strokeWidth: resolved.borderWidth ?? 1.0,
        ),
        child: glassSurface,
      );
    }

    // Tint and refraction gradient
    final baseTint = resolved.tint ?? Colors.white.withValues(alpha: 0.30);
    final surfaceOpacity = (resolved.opacity ?? 0.70).clamp(0.0, 1.0);
    final effectiveTint = baseTint.withValues(
      alpha: (baseTint.a * surfaceOpacity).clamp(0.0, 1.0),
    );

    final glassDecoration = BoxDecoration(
      color: effectiveTint,
      borderRadius: resolvedRadius,
      gradient: resolved.glassGradient,
    );

    Widget core = ClipRRect(
      borderRadius: resolvedRadius,
      clipBehavior: resolved.clipBehavior ?? clipBehavior,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(decoration: glassDecoration, child: glassSurface),
      ),
    );

    // Apply outer shadows
    if (resolved.shadows != null && resolved.shadows!.isNotEmpty) {
      core = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: resolvedRadius,
          boxShadow: resolved.shadows,
        ),
        child: core,
      );
    }

    if (effectiveMargin != null) {
      core = Padding(padding: effectiveMargin, child: core);
    }

    return core;
  }
}

/// A stateful widget that measures its child's intrinsic size,
/// then embeds a native iOS `UIVisualEffectView` Platform View
/// with that measured size.
///
/// This solves the problem of using Platform Views inside
/// `ListView` or other unbounded-height layouts.
class _NativeMeasuredGlass extends StatefulWidget {
  final LiquidGlassOptions resolved;
  final BorderRadius resolvedRadius;
  final double? explicitWidth;
  final double? explicitHeight;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final VoidCallback? onTap;
  final Clip clipBehavior;
  final Widget? child;
  final Widget Function() fallbackBuilder;

  const _NativeMeasuredGlass({
    required this.resolved,
    required this.resolvedRadius,
    this.explicitWidth,
    this.explicitHeight,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
    this.child,
    required this.fallbackBuilder,
  });

  @override
  State<_NativeMeasuredGlass> createState() => _NativeMeasuredGlassState();
}

class _NativeMeasuredGlassState extends State<_NativeMeasuredGlass> {
  Size? _measuredSize;
  final GlobalKey _measureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.explicitWidth != null && widget.explicitHeight != null) {
      _measuredSize = Size(widget.explicitWidth!, widget.explicitHeight!);
    }
    // Schedule size measurement after first layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureChild();
    });
  }

  void _measureChild() {
    final renderBox =
        _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final newSize = renderBox.size;
      if (_measuredSize != newSize) {
        setState(() => _measuredSize = newSize);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = widget.padding ?? widget.resolved.padding;
    final effectiveMargin = widget.margin ?? widget.resolved.margin;
    final cornerRadius = widget.resolvedRadius.topLeft.x;

    // Build the child content
    Widget childContent = Container(
      width: widget.explicitWidth,
      height: widget.explicitHeight,
      constraints: widget.constraints,
      alignment: widget.alignment,
      padding: effectivePadding,
      child: widget.child,
    );

    if (widget.onTap != null) {
      childContent = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: childContent,
      );
    }

    // If we haven't measured yet, render invisibly to measure
    if (_measuredSize == null) {
      Widget result = KeyedSubtree(
        key: _measureKey,
        child: widget.fallbackBuilder(),
      );
      if (effectiveMargin != null) {
        result = Padding(padding: effectiveMargin, child: result);
      }
      return result;
    }

    // We have the measured size — embed native glass
    final nativeWidth = widget.explicitWidth ?? _measuredSize!.width;
    final nativeHeight = widget.explicitHeight ?? _measuredSize!.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget nativeGlass = SizedBox(
      width: nativeWidth,
      height: nativeHeight,
      child: Stack(
        children: [
          // Native glass background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: widget.resolvedRadius,
              child: UiKitView(
                viewType: 'liquidify/glass_container',
                creationParams: {
                  'cornerRadius': cornerRadius,
                  'style': isDark ? 'dark' : 'regular',
                  'showBorder': (widget.resolved.borderWidth ?? 1.0) > 0,
                  'borderWidth': widget.resolved.borderWidth ?? 1.0,
                },
                creationParamsCodec: const StandardMessageCodec(),
              ),
            ),
          ),
          // Flutter child content on top
          Positioned.fill(child: childContent),
        ],
      ),
    );

    if (effectiveMargin != null) {
      nativeGlass = Padding(padding: effectiveMargin, child: nativeGlass);
    }

    return nativeGlass;
  }
}
