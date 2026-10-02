import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../native/native_liquid_glass_segmented.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [SegmentedButton] to an Apple-style segmented glass
/// control.
///
/// **Hybrid Rendering:**
/// - On **iOS**: Uses native `UISegmentedControl` via Platform
///   Views for authentic Liquid Glass.
/// - On **other platforms**: Uses Flutter `LiquidGlassContainer`.
class SegmentedButtonLiquidAdapter<T>
    extends LiquidGlassAdapter<SegmentedButton<T>> {
  const SegmentedButtonLiquidAdapter();

  @override
  Widget build(SegmentedButton<T> widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        // Use native UISegmentedControl on iOS
        if (!kIsWeb && Platform.isIOS) {
          return _buildNativeSegmented(context, widget, options);
        }

        return _buildFlutterSegmented(context, widget, options);
      },
    );
  }

  Widget _buildNativeSegmented(
    BuildContext context,
    SegmentedButton<T> widget,
    LiquidGlassOptions options,
  ) {
    // Extract segment labels
    final labels = widget.segments.map((s) {
      if (s.label is Text) {
        return (s.label as Text).data ?? '';
      }
      return '';
    }).toList();

    // Find selected index
    final selectedIndex = widget.segments.indexWhere(
      (s) => widget.selected.contains(s.value),
    );

    final callback = (widget as dynamic).onSelectionChanged;

    return NativeLiquidGlassSegmented(
      segments: labels,
      selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
      onChanged: callback != null
          ? (index) {
              final value = widget.segments[index].value;
              callback.call(<T>{value});
            }
          : null,
      fallback: _buildFlutterSegmented(context, widget, options),
    );
  }

  Widget _buildFlutterSegmented(
    BuildContext context,
    SegmentedButton<T> widget,
    LiquidGlassOptions options,
  ) {
    final theme = Theme.of(context);
    final outerRadius = options.borderRadius ?? BorderRadius.circular(16.0);
    final innerRadius = BorderRadius.circular(12.0);

    return LiquidGlassContainer(
      options: options.copyWith(
        borderRadius: outerRadius,
        padding: const EdgeInsets.all(4.0),
      ),
      borderRadius: outerRadius,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.segments.map((segment) {
          final isSelected = widget.selected.contains(segment.value);
          final isEnabled = segment.enabled;

          Widget itemContent = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected &&
                  widget.showSelectedIcon &&
                  widget.selectedIcon != null) ...[
                widget.selectedIcon!,
                const SizedBox(width: 6.0),
              ] else if (segment.icon != null) ...[
                segment.icon!,
                const SizedBox(width: 6.0),
              ],
              if (segment.label != null) segment.label!,
            ],
          );

          final textStyle = TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.75),
            fontSize: 14.0,
          );

          Widget segmentWidget = Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle(
              style: textStyle,
              child: IconTheme.merge(
                data: IconThemeData(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  size: 18.0,
                ),
                child: itemContent,
              ),
            ),
          );

          if (isSelected) {
            segmentWidget = LiquidGlassContainer(
              useNative: false,
              options: LiquidGlassOptions(
                blur: 14.0,
                opacity: 0.85,
                tint: theme.brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.75),
                borderRadius: innerRadius,
                borderWidth: 1.0,
                shadows: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              borderRadius: innerRadius,
              child: segmentWidget,
            );
          }

          final callback = (widget as dynamic).onSelectionChanged;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isEnabled && callback != null
                ? () {
                    final newSelection = widget.selected.toSet();
                    if (widget.multiSelectionEnabled) {
                      if (isSelected) {
                        if (widget.emptySelectionAllowed ||
                            newSelection.length > 1) {
                          newSelection.remove(segment.value);
                        }
                      } else {
                        newSelection.add(segment.value);
                      }
                    } else {
                      newSelection.clear();
                      newSelection.add(segment.value);
                    }
                    callback.call(newSelection);
                  }
                : null,
            child: segmentWidget,
          );
        }).toList(),
      ),
    );
  }
}
