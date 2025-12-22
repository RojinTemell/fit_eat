import 'package:flutter/material.dart';

import '../constants/text_constants.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.widget,
    required this.callback,
    this.borderColor,
    this.backgroundColor,
    this.padding,
  });
  final Widget widget;
  final VoidCallback callback;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.all(padding ?? 8),
        // height: height ?? context.dynamicHeight(0.055),
        // width: width ?? context.dynamicHeight(0.065),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Constant.fillWhite(context),
          border: Border.all(
            color: borderColor ?? Constant.borderLight(context),
          ),
        ),
        child: Center(child: widget),
      ),
    );
  }
}
