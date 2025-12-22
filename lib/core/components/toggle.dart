import 'package:flutter/material.dart';

import '../constants/dynamic_constants.dart';
import '../constants/text_constants.dart';

class BaseSwitch extends StatefulWidget {
  final VoidCallback callback;
  final double? height;
  final double? width;
  final bool isOn;
  final bool? isDisabled;

  const BaseSwitch({
    super.key,
    required this.callback,
    required this.isOn,
    this.height,
    this.isDisabled,
    this.width,
  });
  @override
  _BaseSwitchState createState() => _BaseSwitchState();
}

class _BaseSwitchState extends State<BaseSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.callback,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: widget.width ?? context.dynamicWidth(0.11),
        height: widget.height ?? context.dynamicHeight(0.028),
        padding: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: (widget.isDisabled ?? false)
              ? Constant.fillLight(context)
              : widget.isOn
              ? Constant.fillSecondaryBase(context)
              : Constant.borderLight(context),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Align(
          alignment: widget.isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: context.dynamicWidth(0.05),
            height: context.dynamicHeight(0.028),
            decoration: BoxDecoration(
              color: Constant.fillFixWhite(context),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
