import 'package:fit_eat/features/favorite_page/view/favorite.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/text_constants.dart';
import '../../../core/theme/custom_themes/text_theme.dart';
import 'my_lists.dart';

// ignore: must_be_immutable
class ListsTabPage extends StatefulWidget {
  const ListsTabPage({super.key});

  @override
  State<ListsTabPage> createState() => _ListsTabPageState();
}

class _ListsTabPageState extends State<ListsTabPage>
    with SingleTickerProviderStateMixin {
  List<ListsTabType> tabs = ListsTabType.values;

  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(height: 20),
            TabBar(
              indicatorColor: Constant.borderPrimary(context),
              labelColor: Constant.textDarker(context),
              unselectedLabelColor: Constant.textDarker(context),
              labelStyle: Theme.of(context).textTheme.labelBaseStrong,
              unselectedLabelStyle: Theme.of(context).textTheme.labelBaseStrong,
              controller: _tabController,
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.tab,

              tabs: List.generate(
                tabs.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tabs[index].label,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  tabs.length,
                  (index) => tabs[index].page,
                ),
              ),
            ),
          ],
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
        return Favorite();
      case ListsTabType.myLists:
        return MyLists();
    }
  }
}
