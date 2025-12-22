import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/text_constants.dart';

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    super.key,
    required this.isCheck,
    required this.callback,
    required this.title,
  });
  final bool isCheck;
  final VoidCallback callback;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Row(
        children: [
          PhosphorIcon(
            isCheck ? PhosphorIconsFill.checkSquare : PhosphorIconsBold.square,
            color: Constant.iconDark(context),
          ),
          SizedBox(width: 4),
          Text(title, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
