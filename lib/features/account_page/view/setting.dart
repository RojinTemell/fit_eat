import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/components/appbar.dart';
import '../../../core/components/base_button.dart';
import '../../../core/components/list_item_selection.dart';
import '../../../core/components/toggle.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/theme/theme_mode.dart';

class Setting extends StatefulWidget {
  Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  List settingList = [
    {'title': 'Profil Ayarları', "icon": PhosphorIconsBold.gear},
    {'title': 'Dil Ayarları', "icon": PhosphorIconsBold.globe},
    {'title': 'Tariflerim', "icon": PhosphorIconsBold.forkKnife},
    {'title': 'Listelerim', "icon": PhosphorIconsBold.list},
    {'title': 'Beğendiklerim', "icon": PhosphorIconsBold.heart},
  ];

  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        bottomBorder: Constant.fillWhite(context),
        actions: [
          GestureDetector(
            // onTap: () => context.pushNamed(),
            child: PhosphorIcon(
              PhosphorIconsBold.list,
              size: 24,
              color: Constant.iconDark(context),
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: context.dynamicWidth(1),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: EdgeInsets.only(top: 16, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Constant.fillWhite(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Divider(),
                Column(
                  children: List.generate(settingList.length, (index) {
                    return ListItemSelection(
                      leading: PhosphorIcon(settingList[index]['icon']),
                      title: settingList[index]['title'],
                      callback: () {},
                      listItemSelectionType: ListItemSelectionType.selectedFull,
                    );
                  }),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.only(
                    top: 12,
                    left: 0,
                    right: 0,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Constant.fillWhite(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      BaseSwitch(
                        callback: () {
                          setState(() {
                            isDark = !isDark;
                          });
                          themeProvider.toggleThemeMode(
                            isDark ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                        isOn: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: context.symmetricPadding(20, 20),
            child: BaseButton(
              width: context.dynamicWidth(0.9),
              title: 'Çıkış Yap',
              baseButtonType: BaseButtonType.filledRed,
              baseButtonSize: BaseButtonSize.medium,
            ),
          ),
        ],
      ),
    );
  }
}
