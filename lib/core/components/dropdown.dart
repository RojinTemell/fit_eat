import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/dynamic_constants.dart';
import '../constants/text_constants.dart';
import '../theme/custom_themes/text_theme.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    super.key,
    required this.selectedValue,
    this.onchanged,
    required this.list,
    this.width,
    required this.dropdownType,
    required this.dropdownSize,
    this.height,
    this.disabledItems,
    this.dropdownColor,
  });

  final String? selectedValue;
  final List<String> list;
  final ValueChanged<Object?>? onchanged;
  final double? width;
  final double? height;
  final DropdownType dropdownType;
  final DropdownSize dropdownSize;
  final List<String>? disabledItems;
  final Color? dropdownColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.dynamicWidth(0.3),
      height: height ?? dropdownSize.size(context),
      child: DropdownButtonFormField<dynamic>(
        isExpanded: true,
        value: selectedValue,
        items: list.map((amount) {
          final isDisabled = disabledItems?.contains(amount) ?? false;
          return DropdownMenuItem<dynamic>(
            value: amount,
            enabled: !isDisabled,
            child: Text(
              amount,
              style: Theme.of(context).textTheme.labelStrong.copyWith(
                color: isDisabled
                    ? Constant.textBase(context) // soluk gri
                    : (dropdownType == DropdownType.Disabled
                          ? Constant.textBase(context)
                          : Constant.textDarker(context)),
              ),
            ),
          );
        }).toList(),
        hint: Text(
          "Ürün Seçin",
          style: Theme.of(context).textTheme.labelStrong,
        ),
        onChanged: dropdownType == DropdownType.Disabled ? null : onchanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          filled: true,
          fillColor: dropdownColor ?? Constant.fillWhite(context),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: dropdownType.borderColor(context),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: dropdownType.borderColor(context),
              width: 1,
            ),
          ),
        ),
        icon: PhosphorIcon(
          dropdownType == DropdownType.Expanded
              ? PhosphorIcons.caretUp(PhosphorIconsStyle.bold)
              : PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
          size: 12,
          color: Constant.iconDark(context),
        ),
        dropdownColor: Constant.fillWhite(context),
      ),
    );
  }
}

enum DropdownType {
  Default,
  Hover,
  Focused,
  Expanded,
  Selected,
  Error,
  Disabled,
}

enum DropdownSize { Large, Medium, Small }

extension Dropdownsize on DropdownSize {
  double size(BuildContext context) {
    switch (this) {
      case DropdownSize.Large:
        return context.dynamicHeight(0.066);
      case DropdownSize.Medium:
        return context.dynamicHeight(0.056);
      case DropdownSize.Small:
        return context.dynamicHeight(0.048);
    }
  }
}

extension DropdownColor on DropdownType {
  Color borderColor(BuildContext context) {
    switch (this) {
      case DropdownType.Default:
        return Constant.borderLight(context);
      case DropdownType.Hover:
        return Constant.borderDark(context);
      case DropdownType.Focused:
        return Constant.borderDark(context);
      case DropdownType.Expanded:
        return Constant.fillSecondaryBase(context);
      case DropdownType.Selected:
        return Constant.borderLight(context);
      case DropdownType.Error:
        return Constant.errorBorder(context);
      case DropdownType.Disabled:
        return Constant.borderLight(context);
    }
  }
}
