import 'package:fit_eat/features/favorite_page/view/favorite.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/text_constants.dart';

// ignore: must_be_immutable
class ListsTabPage extends StatefulWidget {
  ListsTabPage({super.key});

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
              controller: _tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Constant.borderPrimary(context),
              labelColor: Constant.textDarker(context),
              unselectedLabelColor: Constant.textDark(context),
              labelStyle: const TextStyle(
                height: 16 / 12,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),

              tabs: List.generate(
                tabs.length,
                (index) => Text(
                  tabs[index].label,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
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
        return SizedBox();
    }
  }
}
