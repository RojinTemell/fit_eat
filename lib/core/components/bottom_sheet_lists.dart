import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/dynamic_constants.dart';
import '../constants/text_constants.dart';
import '../theme/custom_themes/text_theme.dart';
import 'list_item_selection.dart';
import 'toggle.dart';

class BottomSheetLists extends StatelessWidget {
  const BottomSheetLists({super.key, required this.bottomList});
  final List<Map<String, dynamic>> bottomList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: PhosphorIcon(
              PhosphorIcons.x(PhosphorIconsStyle.bold),
              color: Constant.iconDark(context),
              size: 20,
            ),
          ),
        ),
        Padding(
          padding: context.symmetricPadding(16, 0),
          child: Column(
            children: List.generate(bottomList.length, (index) {
              var item = bottomList[index];
              return ListItemSelection(
                bgColor: Constant.fillWhite(context),
                titleStyle: Theme.of(context).textTheme.bodySmallStrong
                    .copyWith(
                      color: item['icon'] == PhosphorIconsBold.trash
                          ? Constant.textPrimary(context)
                          : Constant.textDarker(context),
                    ),
                isTrailingIcon: item['isToggle'] != null
                    ? BaseSwitch(callback: () {}, isOn: item['isToggle'])
                    : SizedBox(),
                leading: PhosphorIcon(
                  item['icon'],
                  color: item['icon'] == PhosphorIconsBold.trash
                      ? Constant.iconPrimary(context)
                      : Constant.iconDark(context),
                  size: 20,
                ),
                title: item['title'],
                subtitle: item['subTitle'],
                callback: () {
                  final cb = item['callback'];
                  if (cb != null) {
                    cb(context); // <— burada bottomSheet’in context’i gidiyor
                  }
                },
                listItemSelectionType: ListItemSelectionType.disabledFull,
              );
            }),
          ),
        ),
      ],
    );
  }
}
