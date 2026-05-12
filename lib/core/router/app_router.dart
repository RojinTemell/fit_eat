import 'package:fit_eat/core/components/bottom_nav_bar.dart';
import 'package:fit_eat/features/account_page/view/account.dart';
import 'package:fit_eat/features/auth_page/view/verification_code.dart';
import 'package:fit_eat/features/auth_page/viewmodel/auth_viewmodel.dart';
import 'package:fit_eat/features/favorite_page/view/list_tab_page.dart';
import 'package:fit_eat/features/home_page/view/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/account_page/view/setting.dart';
import '../../features/auth_page/view/forgot_password.dart';
import '../../features/auth_page/view/login.dart';
import '../../features/auth_page/view/sign_up.dart';
import '../../features/create_recipe_page/model/recipe_model.dart';
import '../../features/create_recipe_page/view/categories.dart';
import '../../features/recipe_feed/view/ingredients.dart';
import '../../features/create_recipe_page/view/create_recipe.dart';
import '../../features/home_page/view/answer_questions.dart';
import '../../features/recipe_detail/view/recipe_detail.dart';
import '../../features/home_page/view/profile.dart';
import '../../features/splash_page/view/splash.dart';
import 'auth_redirect.dart';
import 'go_router_refresh_stream.dart';

/// V0.1 router. AuthViewmodel inject edilir — redirect ve refreshListenable
/// kullanıcı state'ini buradan okur, böylece auth state her değişiminde
/// router otomatik yeniden değerlendirir (Pattern 2: redirect +
/// refreshListenable).
///
/// Önceki sürümde [appRouter] static singleton'dı. Bu sürüm factory:
/// main.dart bootstrap edildikten sonra `AppRouter.create(auth)` çağrılır.
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter create(AuthViewmodel auth) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/splash',
      observers: [KeyboardDismissObserver()],
      refreshListenable: GoRouterRefreshStream(auth.stream),
      redirect: (context, state) => authRedirect(state, auth.state),
      routes: [
        StatefulShellRoute.indexedStack(
          builder: ((context, state, shell) => BottomNavBar(shell: shell)),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => Home(),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/listsTabPage',
                  name: 'listsTabPage',
                  builder: (context, state) => ListsTabPage(),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/createRecipe',
                  name: 'createRecipe',
                  builder: (context, state) => CreateRecipe(),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/account',
                  name: 'account',
                  builder: (context, state) => Account(),
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: '/recipeDetail',
          name: 'recipeDetail',
          builder: (context, state) {
            final model = state.extra as RecipeModel;
            return RecipeDetail(model: model);
          },
        ),
        GoRoute(
          path: '/categories',
          name: 'categories',
          builder: (context, state) => Categories(),
          routes: [],
        ),
        GoRoute(
          path: '/ingredientsPage',
          name: 'ingredientsPage',
          builder: (context, state) => IngredientsPage(),
          routes: [],
        ),
        GoRoute(
          path: '/answerQuestions',
          name: 'answerQuestions',
          builder: (context, state) => AnswerQuestions(),
          routes: [],
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => Profile(),
          routes: [],
        ),
        GoRoute(
          path: '/setting',
          name: 'setting',
          builder: (context, state) => Setting(),
          routes: [],
        ),
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => Splash(),
          routes: [],
        ),

        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => Login(),
        ),
        GoRoute(
          path: '/signUp',
          name: 'signUp',
          builder: (context, state) => SignUp(),
        ),
        GoRoute(
          path: '/forgotPassword',
          name: 'forgotPassword',
          builder: (context, state) => ForgotPassword(),
        ),
        // V0.1: route iskeleti — ekran VerificationCode widget'ı var
        // ama AuthOtpPending state'i şu an emit edilmiyor. Forgot
        // password flow'unda kullanılıyor ve gelecek OTP migration'ı için
        // route burada hazır duruyor (auth_redirect.dart pin'i da bu
        // route'a güveniyor).
        GoRoute(
          path: '/verificationCode',
          name: 'verificationCode',
          builder: (context, state) => VerificationCode(),
        ),
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
