import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/text_constants.dart';
import '../theme/custom_themes/text_theme.dart';

class ListItemSelection extends StatelessWidget {
  const ListItemSelection({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.callback,
    this.trailingText,
    this.overline,
    required this.listItemSelectionType,
    this.isTrailingIcon,
    this.flex,
    this.bgColor,
    this.isSelected,
    this.child,
    this.image,
    this.titleStyle,
    this.height,
    this.borderColor,
  });
  final String title;
  final String? subtitle;
  final String? overline;
  final Widget? leading;
  final Widget? image;
  final double? height;
  final int? flex;
  final Widget? isTrailingIcon;
  final Widget? trailingText;
  final VoidCallback callback;
  final ListItemSelectionType listItemSelectionType;
  final Color? bgColor;
  final Color? borderColor;
  final bool? isSelected;
  final Widget? child;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: bgColor ?? Constant.fillWhite(context),
          border: borderColor != null
              ? Border.all(color: borderColor!)
              : listItemSelectionType.border(context),
          borderRadius: listItemSelectionType.borderRadius,
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Center(
            child: Row(
              children: [
                if (leading != null) Expanded(flex: flex ?? 1, child: leading!),
                if (image != null) Expanded(flex: flex ?? 1, child: image!),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (overline != null)
                          Text(
                            overline ?? '',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Constant.textPrimary(context),
                                ),
                          ),
                        if ((isSelected ?? false) && child != null) child!,
                        if (overline != null) SizedBox(height: 2),
                        Text(
                          title,
                          style:
                              titleStyle ??
                              Theme.of(context).textTheme.bodySmallStrong,
                        ),
                        if (subtitle != null) SizedBox(height: 2),
                        if (subtitle != null)
                          Text(
                            subtitle ?? '',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Constant.textBase(context)),
                          ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    trailingText ?? SizedBox(),
                    isTrailingIcon ??
                        PhosphorIcon(
                          PhosphorIcons.caretRight(),
                          size: 18,
                          color: Constant.iconLight(context),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ListItemSelectionType {
  idleFull,
  hoverTapFull,
  selectedFull,
  disabledFull,
  idleCard,
  hoverTapCard,
  selectedCard,
  disabledCard,
}

extension ListItemColor on ListItemSelectionType {
  // Color get borderColor {
  //   switch (this) {
  //     case ListItemSelectionType.idleFull:
  //       return Constant.borderLighter;
  //     case ListItemSelectionType.hoverTapFull:
  //       return Constant.fillWhite;
  //     case ListItemSelectionType.selectedFull:
  //       return Constant.borderLighter;
  //     case ListItemSelectionType.disabledFull:
  //       return Constant.borderLighter;
  //     case ListItemSelectionType.idleCard:
  //       return Constant.fillWhite;
  //     case ListItemSelectionType.hoverTapCard:
  //       return Constant.borderLighter;
  //     case ListItemSelectionType.selectedCard:
  //       return Constant.borderLighter;
  //     case ListItemSelectionType.disabledCard:
  //       return Constant.borderLighter;
  //   }
  // }

  BorderRadiusGeometry get borderRadius {
    switch (this) {
      case ListItemSelectionType.idleCard:
        return BorderRadius.circular(8);
      case ListItemSelectionType.hoverTapCard:
        return BorderRadius.circular(8);
      case ListItemSelectionType.selectedCard:
        return BorderRadius.circular(8);
      case ListItemSelectionType.disabledCard:
        return BorderRadius.circular(8);
      case ListItemSelectionType.idleFull:
        return BorderRadius.circular(0);
      case ListItemSelectionType.hoverTapFull:
        return BorderRadius.circular(0);
      case ListItemSelectionType.selectedFull:
        return BorderRadius.circular(0);
      case ListItemSelectionType.disabledFull:
        return BorderRadius.circular(0);
    }
  }

  BoxBorder border(BuildContext context) {
    switch (this) {
      case ListItemSelectionType.idleFull:
        return Border(
          bottom: BorderSide(color: Constant.borderLighter(context)),
        );
      case ListItemSelectionType.hoverTapFull:
        return Border(
          bottom: BorderSide(color: Constant.borderLighter(context)),
        );
      case ListItemSelectionType.selectedFull:
        return Border(
          bottom: BorderSide(color: Constant.borderLighter(context)),
        );
      case ListItemSelectionType.disabledFull:
        return Border(
          bottom: BorderSide(color: Constant.borderLighter(context)),
        );
      case ListItemSelectionType.idleCard:
        return Border.all(color: Constant.borderLighter(context));
      case ListItemSelectionType.hoverTapCard:
        return Border.all(color: Constant.borderLighter(context));
      case ListItemSelectionType.selectedCard:
        return Border.all(color: Constant.borderLighter(context));
      case ListItemSelectionType.disabledCard:
        return Border.all(color: Constant.borderLighter(context));
    }
  }
}
