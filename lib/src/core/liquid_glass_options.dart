import 'package:flutter/material.dart';

/// Configuration options for the Liquid Glass visual effect.
///
/// Use [LiquidGlassOptions] to customize blur, tint, specular highlights,
/// border gradients, shadows, and platform behavior.
@immutable
class LiquidGlassOptions {
  /// The blur strength applied by the backdrop filter.
  ///
  /// Typical values range from `10.0` to `30.0`. Default is `18.0`.
  final double? blur;

  /// The surface opacity of the glass layer.
  ///
  /// Values range from `0.0` (fully clear) to `1.0` (opaque). Default is `0.70`.
  final double? opacity;

  /// An optional tint color blended into the glass surface.
  ///
  /// If null, default tints adapt automatically to light or dark mode.
  final Color? tint;

  /// An explicit border for the glass container.
  ///
  /// If provided, this overrides [borderGradient].
  final BoxBorder? border;

  /// A specular gradient border reflecting Apple-style liquid glass rims.
  ///
  /// Usually a linear gradient from top-left (light sheen) to bottom-right (ambient).
  final Gradient? borderGradient;

  /// The width of the specular border. Default is `1.0`.
  final double? borderWidth;

  /// The border radius geometry of the glass surface.
  final BorderRadiusGeometry? borderRadius;

  /// An optional internal gradient applied on top of the frosted surface
  /// to simulate light refraction and specular curvature.
  final Gradient? glassGradient;

  /// Outer shadows cast by the glass container.
  final List<BoxShadow>? shadows;

  /// Refraction and specular reflection intensity factor (0.0 to 1.0).
  ///
  /// Defaults to `0.35`.
  final double? refraction;

  /// An optional subtle glow color around the widget when active or hovered.
  final Color? glowColor;

  /// Radius for the glow effect if [glowColor] is provided.
  final double? glowRadius;

  /// Whether micro-animations (e.g. press depressions, gloss shifts) occur on tap.
  /// Defaults to `true`.
  final bool? interactive;

  /// If `true`, forces Liquid Glass rendering on any platform (Android, Web, Desktop),
  /// bypassing the default iOS/macOS platform check.
  final bool force;

  /// If `false`, disables conversion and preserves the original widget.
  /// Defaults to `true`.
  final bool enabled;

  /// Optional margin around the glass container.
  final EdgeInsetsGeometry? margin;

  /// Optional internal padding.
  final EdgeInsetsGeometry? padding;

  /// Clip behavior for the backdrop filter and glass contents.
  /// Defaults to [Clip.antiAlias].
  final Clip? clipBehavior;

  /// Creates a [LiquidGlassOptions] instance.
  const LiquidGlassOptions({
    this.blur,
    this.opacity,
    this.tint,
    this.border,
    this.borderGradient,
    this.borderWidth,
    this.borderRadius,
    this.glassGradient,
    this.shadows,
    this.refraction,
    this.glowColor,
    this.glowRadius,
    this.interactive,
    this.force = false,
    this.enabled = true,
    this.margin,
    this.padding,
    this.clipBehavior,
  });

  /// Preset for a crisp, subtle frosted glass effect.
  const LiquidGlassOptions.frosted({
    this.blur = 20.0,
    this.opacity = 0.65,
    this.tint,
    this.border,
    this.borderGradient,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.glassGradient,
    this.shadows,
    this.refraction = 0.4,
    this.glowColor,
    this.glowRadius,
    this.interactive = true,
    this.force = false,
    this.enabled = true,
    this.margin,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Preset for an ultra-clear, highly refractive liquid glass effect.
  const LiquidGlassOptions.crystal({
    this.blur = 12.0,
    this.opacity = 0.40,
    this.tint,
    this.border,
    this.borderGradient,
    this.borderWidth = 1.2,
    this.borderRadius,
    this.glassGradient,
    this.shadows,
    this.refraction = 0.6,
    this.glowColor,
    this.glowRadius,
    this.interactive = true,
    this.force = false,
    this.enabled = true,
    this.margin,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Preset for a deeply tinted, dark smoke glass aesthetic.
  const LiquidGlassOptions.smoke({
    this.blur = 24.0,
    this.opacity = 0.82,
    this.tint = const Color(0xFF141416),
    this.border,
    this.borderGradient,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.glassGradient,
    this.shadows,
    this.refraction = 0.25,
    this.glowColor,
    this.glowRadius,
    this.interactive = true,
    this.force = false,
    this.enabled = true,
    this.margin,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Creates a copy of this [LiquidGlassOptions] with the given fields replaced.
  LiquidGlassOptions copyWith({
    double? blur,
    double? opacity,
    Color? tint,
    BoxBorder? border,
    Gradient? borderGradient,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
    Gradient? glassGradient,
    List<BoxShadow>? shadows,
    double? refraction,
    Color? glowColor,
    double? glowRadius,
    bool? interactive,
    bool? force,
    bool? enabled,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Clip? clipBehavior,
  }) {
    return LiquidGlassOptions(
      blur: blur ?? this.blur,
      opacity: opacity ?? this.opacity,
      tint: tint ?? this.tint,
      border: border ?? this.border,
      borderGradient: borderGradient ?? this.borderGradient,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      glassGradient: glassGradient ?? this.glassGradient,
      shadows: shadows ?? this.shadows,
      refraction: refraction ?? this.refraction,
      glowColor: glowColor ?? this.glowColor,
      glowRadius: glowRadius ?? this.glowRadius,
      interactive: interactive ?? this.interactive,
      force: force ?? this.force,
      enabled: enabled ?? this.enabled,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Merges another [LiquidGlassOptions] into this one, prioritizing values from [other].
  LiquidGlassOptions merge(LiquidGlassOptions? other) {
    if (other == null) return this;
    return LiquidGlassOptions(
      blur: other.blur ?? blur,
      opacity: other.opacity ?? opacity,
      tint: other.tint ?? tint,
      border: other.border ?? border,
      borderGradient: other.borderGradient ?? borderGradient,
      borderWidth: other.borderWidth ?? borderWidth,
      borderRadius: other.borderRadius ?? borderRadius,
      glassGradient: other.glassGradient ?? glassGradient,
      shadows: other.shadows ?? shadows,
      refraction: other.refraction ?? refraction,
      glowColor: other.glowColor ?? glowColor,
      glowRadius: other.glowRadius ?? glowRadius,
      interactive: other.interactive ?? interactive,
      force: other.force,
      enabled: other.enabled,
      margin: other.margin ?? margin,
      padding: other.padding ?? padding,
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LiquidGlassOptions &&
        other.blur == blur &&
        other.opacity == opacity &&
        other.tint == tint &&
        other.border == border &&
        other.borderGradient == borderGradient &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.glassGradient == glassGradient &&
        other.refraction == refraction &&
        other.glowColor == glowColor &&
        other.glowRadius == glowRadius &&
        other.interactive == interactive &&
        other.force == force &&
        other.enabled == enabled &&
        other.margin == margin &&
        other.padding == padding &&
        other.clipBehavior == clipBehavior;
  }

  @override
  int get hashCode => Object.hash(
    blur,
    opacity,
    tint,
    border,
    borderGradient,
    borderWidth,
    borderRadius,
    glassGradient,
    refraction,
    glowColor,
    glowRadius,
    interactive,
    force,
    enabled,
    margin,
    padding,
    clipBehavior,
  );
}
