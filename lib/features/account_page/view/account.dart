import 'package:fit_eat/core/components/toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/components/list_item_selection.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/theme/theme_mode.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isDark = true;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(color: Constant.fillWhite(context)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Constant.fillBase(context),
                      backgroundImage: NetworkImage(
                        'https://cdn.bynogame.com/shop/shop-default-square-1642511991533.jpeg',
                      ),
                    ),

                    SizedBox(width: 12),
                    SizedBox(
                      height: context.dynamicHeight(0.07),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Rojin Temel',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'rojintemel02@gmail.com',
                              style: Theme.of(context).textTheme.labelSmall,

                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: context.dynamicWidth(1),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.only(top: 16, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Constant.fillWhite(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Easy',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Divider(),
                    Column(
                      children: List.generate(5, (index) {
                        return ListItemSelection(
                          title: 'Settings',
                          callback: () {},
                          listItemSelectionType:
                              ListItemSelectionType.selectedFull,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Container(
                width: context.dynamicWidth(1),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.only(top: 16, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Constant.fillWhite(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Easy',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Divider(),
                    Column(
                      children: List.generate(5, (index) {
                        return ListItemSelection(
                          title: 'Settings',
                          callback: () {},
                          listItemSelectionType:
                              ListItemSelectionType.selectedFull,
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
              Container(
                width: context.dynamicWidth(1),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.only(top: 16, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Constant.fillWhite(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Easy',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Divider(),
                    Column(
                      children: List.generate(5, (index) {
                        return ListItemSelection(
                          title: 'Settings',
                          callback: () {},
                          listItemSelectionType:
                              ListItemSelectionType.selectedFull,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
