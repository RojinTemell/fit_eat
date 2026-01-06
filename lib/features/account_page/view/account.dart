import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/circle_button.dart';
import 'package:fit_eat/core/components/toggle.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
  List settingList = [
    {'title': 'Beğendiklerim', "icon": PhosphorIconsBold.heart},
    {'title': 'Dil Ayarı', "icon": PhosphorIconsBold.globe},
    {'title': 'Tariflerim', "icon": PhosphorIconsBold.forkKnife},
    {'title': 'Listelerim', "icon": PhosphorIconsBold.list},
  ];
  List rozets = [
    'chef',
    'egg',
    'fire',
    'frying_pan',
    'north-pole',
    'rabbit',
    'reward',
    'robot',
    'sunshine',
    'world',
  ];

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
              SizedBox(height: 20),
              Padding(
                padding: context.onlyPadding(0, 0, 0, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Rozetler',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(rozets.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SizedBox(
                              height: context.dynamicHeight(0.1),
                              width: context.dynamicHeight(0.1), // KARE ALAN
                              child: Image.asset(
                                'assets/rozets/${rozets[index]}.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Container(
                            //   height: context.dynamicHeight(0.1),
                            //   width: context.dynamicWidth(0.18),
                            //   // color: Colors.amber,
                            //   child: Image.asset(
                            //     'assets/rozets/${rozets[index]}.png',

                            //     height: context.dynamicHeight(0.1),
                            //     width: context.dynamicWidth(0.2),
                            //     fit: BoxFit.fitHeight,
                            //   ),
                            // ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: context.dynamicWidth(1),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Constant.fillWhite(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        // PhosphorIcon(PhosphorIconsBold.heart),
                        Text(
                          '613',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Following',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        // PhosphorIcon(PhosphorIconsBold.heart),
                        Text(
                          '233.3K',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Followers',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        // PhosphorIcon(PhosphorIconsBold.heart),
                        Text(
                          '112M',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Likes',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        // PhosphorIcon(PhosphorIconsBold.heart),
                        Text(
                          '113',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Recipes',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     // PhosphorIcon(PhosphorIconsBold.shareFat),
                    //     SizedBox(height: 4),
                    //     Text(
                    //       '1,876',
                    //       style: Theme.of(context).textTheme.labelMedium,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // SizedBox(height: 20),
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

              Padding(
                padding: context.symmetricPadding(20, 20),
                child: BaseButton(
                  width: context.dynamicWidth(0.9),
                  title: 'Çıkış Yap',
                  baseButtonType: BaseButtonType.filledGrey,
                  baseButtonSize: BaseButtonSize.medium,
                ),
              ),
              // SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
