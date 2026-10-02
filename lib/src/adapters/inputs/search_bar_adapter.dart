import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../native/native_liquid_glass_search_bar.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [SearchBar] to an Apple-style Liquid Glass search pill.
///
/// **Hybrid Rendering:**
/// - On **iOS**: Uses native `UISearchBar` via Platform Views.
/// - On **other platforms**: Uses Flutter `TextField` inside
///   `LiquidGlassContainer`.
class SearchBarLiquidAdapter extends LiquidGlassAdapter<SearchBar> {
  const SearchBarLiquidAdapter();

  @override
  Widget build(SearchBar widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        // Use native UISearchBar on iOS
        if (!kIsWeb && Platform.isIOS) {
          return NativeLiquidGlassSearchBar(
            text: widget.controller?.text,
            placeholder: widget.hintText,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            fallback: _buildFlutterSearchBar(context, widget, options),
          );
        }

        return _buildFlutterSearchBar(context, widget, options);
      },
    );
  }

  Widget _buildFlutterSearchBar(
    BuildContext context,
    SearchBar widget,
    LiquidGlassOptions options,
  ) {
    final theme = Theme.of(context);
    final radius = options.borderRadius ?? BorderRadius.circular(24.0);

    final leadingWidget =
        widget.leading ?? const Icon(Icons.search, size: 20.0);

    final trailingWidgets = widget.trailing?.toList() ?? [];

    return LiquidGlassContainer(
      options: options.copyWith(
        borderRadius: radius,
        blur: options.blur ?? 18.0,
      ),
      borderRadius: radius,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              enabled: widget.enabled,
              autofocus: widget.autoFocus,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.50),
                  fontSize: 15.0,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 15.0,
              ),
            ),
          ),
          if (trailingWidgets.isNotEmpty) ...[
            const SizedBox(width: 8.0),
            ...trailingWidgets,
          ],
        ],
      ),
    );
  }
}
