import 'package:fit_eat/core/components/bottom_nav_bar.dart';
import 'package:fit_eat/features/account_page/view/account.dart';
import 'package:fit_eat/features/favorite_page/view/list_tab_page.dart';
import 'package:fit_eat/features/home_page/view/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/account_page/view/setting.dart';
import '../../features/ai_asistan_page/view/ai_assist.dart';
import '../../features/auth_page/view/forgot_password.dart';
import '../../features/auth_page/view/login.dart';
import '../../features/auth_page/view/sign_up.dart';
import '../../features/auth_page/view/verification_code.dart';
import '../../features/create_recipe_page/view/categories.dart';
import '../../features/create_recipe_page/view/categories_sub_liste.dart';
import '../../features/create_recipe_page/view/create_recipe.dart';
import '../../features/home_page/view/answer_questions.dart';
import '../../features/home_page/view/product_detail.dart';
import '../../features/home_page/view/profile.dart';
import '../../features/splash_page/view/splash.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter appRouter = createRouter();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: "/splash",
      observers: [KeyboardDismissObserver()],
      routes: [
        StatefulShellRoute.indexedStack(
          builder: ((context, state, shell) => BottomNavBar(shell: shell)),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/home",
                  name: "home",
                  builder: (context, state) => Home(),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/listsTabPage",
                  name: "listsTabPage",
                  builder: (context, state) => ListsTabPage(),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/createRecipe",
                  name: "createRecipe",
                  builder: (context, state) => CreateRecipe(),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/aiAssist",
                  name: "aiAssist",
                  builder: (context, state) => AiAssist(),
                ),
                // GoRoute(
                //   path: "/signUp",
                //   name: "signUp",
                //   builder: (context, state) => SignUp(),
                // ),
                // GoRoute(
                //   path: "/login",
                //   name: "login",
                //   builder: (context, state) => Login(),
                // ),
                // GoRoute(
                //   path: "/forgotPassword",
                //   name: "forgotPassword",
                //   builder: (context, state) => ForgotPassword(),
                // ),
                // GoRoute(
                //   path: "/verificationCode",
                //   name: "verificationCode",
                //   builder: (context, state) => VerificationCode(),
                // ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/account",
                  name: "account",
                  builder: (context, state) => Account(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: "/productDetail",
          name: "productDetail",
          builder: (context, state) => ProductDetail(),
        ),
        GoRoute(
          path: "/categories",
          name: "categories",
          builder: (context, state) => Categories(),
          routes: [],
        ),
        GoRoute(
          path: "/categoriesSubListe",
          name: "categoriesSubListe",
          builder: (context, state) => CategoriesSubListe(),
          routes: [],
        ),
        GoRoute(
          path: "/answerQuestions",
          name: "answerQuestions",
          builder: (context, state) => AnswerQuestions(),
          routes: [],
        ),
        GoRoute(
          path: "/profile",
          name: "profile",
          builder: (context, state) => Profile(),
          routes: [],
        ),
        GoRoute(
          path: "/setting",
          name: "setting",
          builder: (context, state) => Setting(),
          routes: [],
        ),
        GoRoute(
          path: "/splash",
          name: "splash",
          builder: (context, state) => Splash(),
          routes: [],
        ),

        // GoRoute(
        //   path: "/login",
        //   name: "login",
        //   builder: (context, state) => Login(),
        // ),
        // GoRoute(
        //   path: "/signUp",
        //   name: "signUp",
        //   builder: (context, state) => SignUp(),
        // ),
        // GoRoute(
        //   path: "/forgotPassword",
        //   name: "forgotPassword",
        //   builder: (context, state) => ForgotPassword(),
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
