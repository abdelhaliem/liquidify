import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [Chip] to Liquid Glass styling.
class ChipLiquidAdapter extends LiquidGlassAdapter<Chip> {
  const ChipLiquidAdapter();

  @override
  Widget build(Chip widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final radius = options.borderRadius ?? BorderRadius.circular(16.0);

        return LiquidGlassContainer(
          options: options.copyWith(
            borderRadius: radius,
            tint: options.tint ?? widget.backgroundColor,
          ),
          borderRadius: radius,
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.avatar != null) ...[
                widget.avatar!,
                const SizedBox(width: 6.0),
              ],
              widget.label,
              if (widget.onDeleted != null) ...[
                const SizedBox(width: 4.0),
                GestureDetector(
                  onTap: widget.onDeleted,
                  child:
                      widget.deleteIcon ?? const Icon(Icons.cancel, size: 16.0),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Adapts [FilterChip] to Liquid Glass styling.
class FilterChipLiquidAdapter extends LiquidGlassAdapter<FilterChip> {
  const FilterChipLiquidAdapter();

  @override
  Widget build(FilterChip widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final radius = options.borderRadius ?? BorderRadius.circular(16.0);
        final isSelected = widget.selected;

        final tint = isSelected
            ? (options.tint ??
                  theme.colorScheme.primary.withValues(alpha: 0.35))
            : options.tint;

        return GestureDetector(
          onTap: widget.onSelected != null
              ? () => widget.onSelected!(!isSelected)
              : null,
          child: LiquidGlassContainer(
            options: options.copyWith(borderRadius: radius, tint: tint),
            borderRadius: radius,
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check, size: 16.0),
                  const SizedBox(width: 6.0),
                ] else if (widget.avatar != null) ...[
                  widget.avatar!,
                  const SizedBox(width: 6.0),
                ],
                widget.label,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Adapts [ChoiceChip] to Liquid Glass styling.
class ChoiceChipLiquidAdapter extends LiquidGlassAdapter<ChoiceChip> {
  const ChoiceChipLiquidAdapter();

  @override
  Widget build(ChoiceChip widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final radius = options.borderRadius ?? BorderRadius.circular(16.0);
        final isSelected = widget.selected;

        final tint = isSelected
            ? (options.tint ??
                  theme.colorScheme.primary.withValues(alpha: 0.35))
            : options.tint;

        return GestureDetector(
          onTap: widget.onSelected != null
              ? () => widget.onSelected!(!isSelected)
              : null,
          child: LiquidGlassContainer(
            options: options.copyWith(borderRadius: radius, tint: tint),
            borderRadius: radius,
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.avatar != null) ...[
                  widget.avatar!,
                  const SizedBox(width: 6.0),
                ],
                widget.label,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Adapts [ActionChip] to Liquid Glass styling.
class ActionChipLiquidAdapter extends LiquidGlassAdapter<ActionChip> {
  const ActionChipLiquidAdapter();

  @override
  Widget build(ActionChip widget, LiquidGlassOptions options) {
    final radius = options.borderRadius ?? BorderRadius.circular(16.0);

    return GestureDetector(
      onTap: widget.onPressed,
      child: LiquidGlassContainer(
        options: options.copyWith(
          borderRadius: radius,
          tint: options.tint ?? widget.backgroundColor,
        ),
        borderRadius: radius,
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.avatar != null) ...[
              widget.avatar!,
              const SizedBox(width: 6.0),
            ],
            widget.label,
          ],
        ),
      ),
    );
  }
}
