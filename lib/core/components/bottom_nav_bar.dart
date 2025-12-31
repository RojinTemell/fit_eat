// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/text_constants.dart';

final ValueNotifier<bool> showBottomBar = ValueNotifier(true);

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  void resetNavigation() {
    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted) {
        widget.shell.goBranch(0, initialLocation: true);
      }
    });
  }

  final List<BottomTabType> tabs = BottomTabType.values;
  int? lastTappedIndex;
  DateTime? lastTappedTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Constant.fillWhite(context),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: showBottomBar,
        builder: (context, value, _) {
          return value
              ? BottomNavigationBar(
                  backgroundColor: Constant.fillWhite(context),
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  selectedItemColor: Constant.iconDark(context),
                  unselectedItemColor: Constant.iconDark(context),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  selectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) {
                    final now = DateTime.now();
                    if (lastTappedIndex == value &&
                        lastTappedTime != null &&
                        now.difference(lastTappedTime!) <
                            const Duration(milliseconds: 300)) {
                      widget.shell.goBranch(value, initialLocation: true);
                    } else {
                      //widget.shell.goBranch(value, initialLocation: true);
                      widget.shell.goBranch(value);
                    }

                    lastTappedIndex = value;
                    lastTappedTime = now;
                  },
                  currentIndex: widget.shell.currentIndex,
                  items: List.generate(
                    tabs.length,
                    (index) => tabItem(
                      tabs[index],
                      widget.shell.currentIndex == index,
                    ),
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
      body: widget.shell,
    );
  }

  BottomNavigationBarItem tabItem(BottomTabType tab, bool isSelected) {
    return BottomNavigationBarItem(
      label: tab.title,
      icon: SizedBox(
        width: 26,
        height: 26,
        child: PhosphorIcon(
          tab.icon(
            isSelected ? PhosphorIconsStyle.fill : PhosphorIconsStyle.bold,
          ),
          size: 20,
        ),
      ),
    );
  }
}

enum BottomTabType { home, listsTabPage, signUp, account }

extension BottomTabExtension on BottomTabType {
  String get label => name;

  String get title {
    switch (this) {
      case BottomTabType.home:
        return 'Home';
      case BottomTabType.listsTabPage:
        return 'My Lists';
      case BottomTabType.signUp:
        return 'Sign up';
      case BottomTabType.account:
        return "Account";
    }
  }

  IconData icon(PhosphorIconsStyle style) {
    switch (this) {
      case BottomTabType.home:
        return PhosphorIcons.houseSimple(style);
      case BottomTabType.listsTabPage:
        return PhosphorIcons.squaresFour(style);
      case BottomTabType.signUp:
        return PhosphorIcons.heart(style);
      case BottomTabType.account:
        return PhosphorIcons.user(style);
    }
  }
}
