import 'package:fit_eat/features/home_page/test_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter appRouter = createRouter();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: "/test",
      observers: [KeyboardDismissObserver()],
      routes: [
        GoRoute(
          path: "/test",
          name: "test",
          builder: (context, state) => TestPage(),
        ),
        // StatefulShellRoute.indexedStack(
        //   // builder: (context, state, navigationShell) => ,
        //   branches: [
        //     StatefulShellBranch(
        //       routes: [
        //         GoRoute(
        //           path: "/test",
        //           name: "test",
        //           builder: (context, state) => TestPage(),
        //         ),
        //       ],
        //     ),
        //     // StatefulShellBranch(routes: []),
        //   ],
        // ),
      ],
    );
  }
}

class KeyboardDismissObserver extends NavigatorObserver {
  void _unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _unfocus();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _unfocus();

  void didPopNext(Route<dynamic> nextRoute) => _unfocus();
}
