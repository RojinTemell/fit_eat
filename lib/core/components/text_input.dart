import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/dynamic_constants.dart';
import '../constants/text_constants.dart';
import '../theme/custom_themes/text_theme.dart';

class TextInputWidget extends StatelessWidget {
  const TextInputWidget({
    super.key,
    required this.controller,
    this.buildCounter,
    this.onChanged,
    this.hintText,
    required this.keyboardType,
    this.title,
    this.textStyle,
    this.readOnly,
    this.isPassword,
    this.suffixIcon,
    this.prefixIcon,
    this.prefix,
    this.isRequired,
    this.errorText,
    this.focusNode,
    this.height,
    this.borderColor,
    this.fillColor,
    this.onEditingComplete,
    this.onTap,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
    // this.textkey,
  });

  final TextEditingController controller;
  final InputCounterWidgetBuilder? buildCounter;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final String? hintText;
  final String? errorText;
  final String? title;
  final TextStyle? textStyle;
  final TextInputType keyboardType;
  final bool? readOnly;
  final bool? isPassword;
  final bool? isRequired;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final FocusNode? focusNode;
  final double? height;
  final Color? borderColor;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  // final Key? textkey;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final bool obscure = isPassword ?? false;

    // Multiline istendi mi?
    final int effectiveMaxLines = (maxLines ?? 1) < 1 ? 1 : (maxLines ?? 1);
    final int effectiveMinLines = (minLines ?? 1) < 1 ? 1 : (minLines ?? 1);
    final bool multiline = effectiveMaxLines > 1 || effectiveMinLines > 1;

    // Tek satırda sabit ve stabil padding (yukarı yapışma problemini çözer)
    // final bool _obscure = isPassword ?? false;
    // final bool _useExpands = !_obscure; // şifre değilse expands serbest
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Row(
            children: [
              Text(
                title ?? '',
                style: Theme.of(context).textTheme.labelBaseStrong.copyWith(
                  color: (errorText != '' && errorText != null)
                      ? Constant.errorIcon(context)
                      : (Constant.textDarker(context)),
                ),
              ),
              SizedBox(width: 2),
              if (isRequired ?? false)
                Text(
                  '*',
                  style: Theme.of(context).textTheme.labelBaseStrong.copyWith(
                    color: Constant.errorIcon(context),
                  ),
                ),
            ],
          ),
        if (title != null) SizedBox(height: 2),
        SizedBox(
          height: height ?? context.dynamicHeight(0.06),
          child: TextField(
            // key: textkey ?? UniqueKey(),
            readOnly: readOnly ?? false,
            enableInteractiveSelection: !(readOnly ?? false),
            expands: false,

            // ✅ Tek satır / çok satır kontrolü
            maxLines: multiline ? effectiveMaxLines : 1,
            minLines: multiline ? effectiveMinLines : 1,
            // expands: _useExpands,
            // maxLines: _useExpands ? null : 1,
            // minLines: _useExpands ? null : 1,
            onEditingComplete: onEditingComplete,
            focusNode: focusNode,
            style: textStyle ?? Theme.of(context).textTheme.labelStrong,
            cursorColor: Constant.fillPrimaryBase(context),
            controller: controller,
            obscureText: obscure,
            obscuringCharacter: '*',
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            onTap: onTap,
            buildCounter: buildCounter,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              prefix: prefix,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: borderColor ?? Constant.textBase(context),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: (errorText != '' && errorText != null)
                      ? (Constant.errorBorder(context))
                      : (Constant.borderLight(context)),
                ),
              ),
              // errorBorder: OutlineInputBorder(
              //     borderRadius: context.allCircular(10),
              //     borderSide: BorderSide(color: Constant.errorIcon)),
              // focusedErrorBorder: OutlineInputBorder(
              //     borderRadius: context.allCircular(10),
              //     borderSide: BorderSide(color: Constant.errorIcon)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  // ignore: unrelated_type_equality_checks
                  color: (errorText != '' && errorText != null)
                      ? Constant.errorBorder(context)
                      : Constant.borderLight(context),
                ),
              ),
              fillColor: fillColor ?? Constant.fillWhite(context),
              contentPadding: EdgeInsets.symmetric(
                vertical: obscure
                    ? (8 + (height ?? context.dynamicHeight(0.06)) - 38)
                    : 8,
                horizontal: 12,
              ),
              filled: true,
            ),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              errorText ?? '',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Constant.errorText(context),
              ),
            ),
          ),
      ],
    );
  }
}
