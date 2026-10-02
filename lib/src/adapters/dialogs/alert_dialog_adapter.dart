import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [AlertDialog] to an Apple-style frosted Liquid Glass dialog.
class AlertDialogLiquidAdapter extends LiquidGlassAdapter<AlertDialog> {
  const AlertDialogLiquidAdapter();

  @override
  Widget build(AlertDialog widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final radius = options.borderRadius ?? BorderRadius.circular(22.0);

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding:
              widget.insetPadding ??
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          clipBehavior: Clip.none,
          alignment: widget.alignment,
          child: LiquidGlassContainer(
            options: options.copyWith(
              borderRadius: radius,
              blur: options.blur ?? 28.0,
              opacity: options.opacity ?? 0.82,
              shadows:
                  options.shadows ??
                  [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 30.0,
                      offset: const Offset(0, 15),
                      spreadRadius: -4,
                    ),
                  ],
            ),
            borderRadius: radius,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.title != null) ...[
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    child: widget.title!,
                  ),
                  const SizedBox(height: 12.0),
                ],
                if (widget.content != null) ...[
                  Flexible(
                    child: widget.scrollable
                        ? SingleChildScrollView(child: widget.content!)
                        : widget.content!,
                  ),
                  const SizedBox(height: 20.0),
                ],
                if (widget.actions != null && widget.actions!.isNotEmpty)
                  OverflowBar(
                    alignment: widget.actionsAlignment ?? MainAxisAlignment.end,
                    spacing: 8.0,
                    overflowSpacing: 8.0,
                    children: widget.actions!,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
