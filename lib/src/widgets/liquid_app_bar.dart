import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/liquid_glass_options.dart';
import 'liquid_glass_container.dart';

/// An Apple-style frosted Liquid Glass app bar implementing
/// [PreferredSizeWidget].
///
/// Uses native `UIVisualEffectView` on iOS for authentic Apple
/// system glass appearance, or Flutter's `BackdropFilter` fallback
/// on other platforms.
class LiquidAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The underlying [AppBar].
  final AppBar appBar;

  /// Custom Liquid Glass options.
  final LiquidGlassOptions? options;

  /// Creates a [LiquidAppBar].
  const LiquidAppBar({super.key, required this.appBar, this.options});

  @override
  Size get preferredSize => appBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    final mergedOptions = (options ?? const LiquidGlassOptions()).copyWith(
      borderRadius: options?.borderRadius ?? BorderRadius.zero,
      blur: options?.blur ?? 24.0,
      opacity: options?.opacity ?? 0.75,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shouldUseNative =
        !kIsWeb && Platform.isIOS && (options?.force != false);

    return PreferredSize(
      preferredSize: preferredSize,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // Glass background layer - native UIKit view on iOS
          Positioned.fill(
            child: shouldUseNative
                ? UiKitView(
                    viewType: 'liquidify/glass_container',
                    creationParams: {
                      'cornerRadius': 0.0,
                      'style': isDark ? 'dark' : 'regular',
                      'showBorder': true,
                      'borderWidth': 0.5,
                    },
                    creationParamsCodec: StandardMessageCodec(),
                  )
                : LiquidGlassContainer(
                    options: mergedOptions,
                    borderRadius: BorderRadius.zero,
                  ),
          ),
          // Transparent AppBar content on top
          AppBar(
            key: appBar.key,
            leading: appBar.leading,
            automaticallyImplyLeading: appBar.automaticallyImplyLeading,
            title: appBar.title,
            actions: appBar.actions,
            flexibleSpace: appBar.flexibleSpace,
            bottom: appBar.bottom,
            elevation: 0,
            scrolledUnderElevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: appBar.shape,
            backgroundColor: Colors.transparent,
            foregroundColor: appBar.foregroundColor,
            iconTheme: appBar.iconTheme,
            actionsIconTheme: appBar.actionsIconTheme,
            primary: appBar.primary,
            centerTitle: appBar.centerTitle,
            excludeHeaderSemantics: appBar.excludeHeaderSemantics,
            titleSpacing: appBar.titleSpacing,
            toolbarOpacity: appBar.toolbarOpacity,
            bottomOpacity: appBar.bottomOpacity,
            toolbarHeight: appBar.toolbarHeight,
            leadingWidth: appBar.leadingWidth,
          ),
        ],
      ),
    );
  }
}
