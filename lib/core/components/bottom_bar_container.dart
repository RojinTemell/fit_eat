import 'package:flutter/material.dart';
import '../constants/dynamic_constants.dart';
import '../constants/text_constants.dart';
import 'base_button.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.title,
    this.suffixIcon,
    this.prefixIcon,
    this.width,
    this.callback,
    this.baseButtonType,
    this.color,
  });
  final String title;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? width;
  final BaseButtonType? baseButtonType;
  final VoidCallback? callback;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Constant.fillWhite(context),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: context.onlyPadding(12, 12, 12, 12),
      child: SafeArea(
        child: BaseButton(
          baseButtonSize: BaseButtonSize.medium,
          suffixIcon: suffixIcon,
          title: title,
          callback: callback,
          width: width ?? context.dynamicWidth(1),
          baseButtonType: baseButtonType ?? BaseButtonType.filledDark,
        ),
      ),
    );
  }
}
