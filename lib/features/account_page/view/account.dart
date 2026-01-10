import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List rozets = [
    'reward',
    'robot',
    'sunshine',
    'world',
    'chef',
    'fire',
    'frying_pan',
    'egg',
    'north-pole',
    'rabbit',
  ];
  final List<ListsTabType> tabs = ListsTabType.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: tabs.length,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Constant.bgBase(context),
                  expandedHeight: context.dynamicHeight(0.12),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Constant.fillWhite(context),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 4,
                                      right: 4,
                                    ),
                                    child: CircleAvatar(
                                      radius: 38,
                                      backgroundColor: Constant.fillBase(
                                        context,
                                      ),
                                      backgroundImage: NetworkImage(
                                        'https://media.istockphoto.com/id/1437816897/photo/business-woman-manager-or-human-resources-portrait-for-career-success-company-we-are-hiring.jpg?s=612x612&w=0&k=20&c=tyLvtzutRh22j9GqSGI33Z4HpIwv9vL_MZw_xOE19NQ=',
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Constant.fillWhite(
                                          context,
                                        ), // arka plan rengi
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: () => context.pushNamed('setting'),
                                      child: PhosphorIcon(
                                        PhosphorIconsFill.plusCircle,
                                        size: 30,
                                        color: Constant.iconSecondaryDark(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'rojintemel02@gmail.com',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall,

                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: GestureDetector(
                            onTap: () => context.pushNamed('setting'),
                            child: PhosphorIcon(
                              PhosphorIconsBold.list,
                              size: 24,
                              color: Constant.iconDark(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Constant.bgBase(context),
                  expandedHeight: context.dynamicHeight(0.1),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      width: context.dynamicWidth(1),
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      padding: context.symmetricPadding(12, 38),
                      decoration: BoxDecoration(
                        color: Constant.fillWhite(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // PhosphorIcon(PhosphorIconsBold.heart),
                              Text(
                                '613',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Following',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // PhosphorIcon(PhosphorIconsBold.heart),
                              Text(
                                '233.3K',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Followers',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // PhosphorIcon(PhosphorIconsBold.heart),
                              Text(
                                '112M',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Likes',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // PhosphorIcon(PhosphorIconsBold.heart),
                              Text(
                                '113',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Recipes',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(padding: const EdgeInsets.only(bottom: 8)),
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Constant.fillWhite(context),
                  expandedHeight: context.dynamicHeight(0.16),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: context.onlyPadding(0, 0, 8, 0),
                      child: Container(
                        color: Constant.fillWhite(context),
                        padding: context.onlyPadding(16, 0, 16, 20),
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
                                    padding: const EdgeInsets.only(right: 4),
                                    child: SizedBox(
                                      height: context.dynamicHeight(0.07),
                                      width: context.dynamicHeight(0.07),
                                      child: Image.asset(
                                        'assets/rozets/${rozets[index]}.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(padding: const EdgeInsets.only(bottom: 8)),
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  toolbarHeight: context.dynamicHeight(0.012),
                  backgroundColor: Constant.fillWhite(context),
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Constant.borderPrimary(context),
                    labelColor: Constant.textDarker(context),
                    unselectedLabelColor: Constant.textDarker(context),
                    tabs: tabs.map((e) => Tab(text: e.label)).toList(),
                  ),
                ),
              ];
            },

            body: TabBarView(
              controller: _tabController,
              children: tabs.map((tab) {
                return CustomScrollView(
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 2 kolon
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 1, // kare
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                          ),
                        );
                      }, childCount: 20),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

enum ListsTabType { favorite, myLists }

extension ListsTabExtension on ListsTabType {
  String get label {
    switch (this) {
      case ListsTabType.favorite:
        return 'Favorites';
      case ListsTabType.myLists:
        return 'My Lists';
    }
  }

  Widget get page {
    switch (this) {
      case ListsTabType.favorite:
        return SizedBox();
      case ListsTabType.myLists:
        return Container(color: Colors.red);
    }
  }
}
