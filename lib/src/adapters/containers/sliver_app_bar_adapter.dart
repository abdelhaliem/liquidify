import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [SliverAppBar] to Liquid Glass styling.
class SliverAppBarLiquidAdapter extends LiquidGlassAdapter<SliverAppBar> {
  const SliverAppBarLiquidAdapter();

  @override
  Widget build(SliverAppBar widget, LiquidGlassOptions options) {
    final mergedOptions = options.copyWith(
      borderRadius: options.borderRadius ?? BorderRadius.zero,
      blur: options.blur ?? 24.0,
      opacity: options.opacity ?? 0.75,
    );

    return SliverAppBar(
      key: widget.key,
      leading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      title: widget.title,
      actions: widget.actions,
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: LiquidGlassContainer(
              options: mergedOptions,
              borderRadius: BorderRadius.zero,
            ),
          ),
          if (widget.flexibleSpace != null) widget.flexibleSpace!,
        ],
      ),
      bottom: widget.bottom,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      foregroundColor: widget.foregroundColor,
      iconTheme: widget.iconTheme,
      actionsIconTheme: widget.actionsIconTheme,
      primary: widget.primary,
      centerTitle: widget.centerTitle,
      excludeHeaderSemantics: widget.excludeHeaderSemantics,
      titleSpacing: widget.titleSpacing,
      collapsedHeight: widget.collapsedHeight,
      expandedHeight: widget.expandedHeight,
      floating: widget.floating,
      pinned: widget.pinned,
      snap: widget.snap,
      stretch: widget.stretch,
      stretchTriggerOffset: widget.stretchTriggerOffset,
      onStretchTrigger: widget.onStretchTrigger,
      shape: widget.shape,
      toolbarHeight: widget.toolbarHeight,
      leadingWidth: widget.leadingWidth,
    );
  }
}
