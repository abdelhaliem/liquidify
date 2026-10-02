// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/liquid_glass_adapter.dart';
import '../../core/liquid_glass_options.dart';
import '../../native/native_liquid_glass_text_field.dart';
import '../../widgets/liquid_glass_container.dart';

/// Adapts [TextField] to a sleek Liquid Glass input container.
///
/// On iOS, uses native [NativeLiquidGlassTextField] with `UITextField`
/// and Apple's glass material when possible, or uses [LiquidGlassContainer]
/// with native `UIVisualEffectView` behind complex Flutter decorations.
class TextFieldLiquidAdapter extends LiquidGlassAdapter<TextField> {
  const TextFieldLiquidAdapter();

  @override
  Widget build(TextField widget, LiquidGlassOptions options) {
    return Builder(
      builder: (context) {
        final radius = (options.borderRadius ?? BorderRadius.circular(14.0))
            .resolve(Directionality.maybeOf(context));
        final originalDecoration = widget.decoration ?? const InputDecoration();

        // Check if suitable for direct native iOS UITextField platform view
        final isSimpleSingleLine =
            (widget.maxLines == null || widget.maxLines == 1) &&
            !widget.obscureText &&
            originalDecoration.prefixIcon == null &&
            originalDecoration.suffixIcon == null;

        if (!kIsWeb && Platform.isIOS && isSimpleSingleLine) {
          return NativeLiquidGlassTextField(
            text: widget.controller?.text,
            placeholder: originalDecoration.hintText,
            label: originalDecoration.labelText,
            cornerRadius: radius.topLeft.x,
            onChanged: (val) {
              if (widget.controller != null && widget.controller!.text != val) {
                widget.controller!.text = val;
              }
              widget.onChanged?.call(val);
            },
            onSubmitted: widget.onSubmitted,
            fallback: _buildFlutterFallback(
              widget,
              options,
              radius,
              originalDecoration,
            ),
          );
        }

        return _buildFlutterFallback(
          widget,
          options,
          radius,
          originalDecoration,
        );
      },
    );
  }

  Widget _buildFlutterFallback(
    TextField widget,
    LiquidGlassOptions options,
    BorderRadius radius,
    InputDecoration originalDecoration,
  ) {
    final adaptedDecoration = originalDecoration.copyWith(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      filled: false,
      contentPadding:
          originalDecoration.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );

    final adaptedTextField = TextField(
      key: widget.key,
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: adaptedDecoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      mouseCursor: widget.mouseCursor,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      clipBehavior: widget.clipBehavior,
      restorationId: widget.restorationId,
      scribbleEnabled: widget.scribbleEnabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      canRequestFocus: widget.canRequestFocus,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration: widget.magnifierConfiguration,
    );

    return LiquidGlassContainer(
      options: options.copyWith(borderRadius: radius),
      borderRadius: radius,
      child: adaptedTextField,
    );
  }
}
