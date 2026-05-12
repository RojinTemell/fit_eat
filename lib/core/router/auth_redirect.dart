import 'package:go_router/go_router.dart';
import '../../features/auth_page/state/auth_state.dart';

String? authRedirect(GoRouterState routerState, AuthState authState) {
  final loc = routerState.matchedLocation;

  if (authState is AuthInitial) {
    return loc == '/splash' ? null : '/splash';
  }

  if (authState is AuthOtpPending) {
    return loc == '/verificationCode' ? null : '/verificationCode';
  }

  if (loc == '/splash') {
    return switch (authState) {
      AuthAuthenticated() => '/home',
      AuthAnonymous() => '/home',
      AuthUnauthenticated() => '/login',
      AuthInitial() || AuthOtpPending() => null, // yukarıda yakalandı
    };
  }

  // ── 3. Korumalı route kontrolü ──────────────────────────────────────
  if (_protectedRoutes.contains(loc)) {
    switch (authState) {
      case AuthAuthenticated():
        return null; // izin var
      case AuthAnonymous() || AuthUnauthenticated():
        return '/login?from=${Uri.encodeQueryComponent(loc)}';
      case AuthInitial() || AuthOtpPending():
        return null; // yukarıda yakalandı
    }
  }

  // ── 4. Auth ekranlarına authed kullanıcı erişimi ────────────────────
  if (_authOnlyEntryRoutes.contains(loc)) {
    if (authState is AuthAuthenticated) {
      final from = routerState.uri.queryParameters['from'];
      return (from != null && from.isNotEmpty) ? from : '/home';
    }
  }

  return null;
}

/// Anon/unauthenticated erişimi engellenen route'lar.
/// V0.1: listsTabPage da burada — anon kullanıcı favorileri görüntüleyemez,
/// /login'e yönlendirilir. V0.5'te empty state ile soft prompt'a geçeriz.
const _protectedRoutes = <String>{
  '/createRecipe',
  '/account',
  '/listsTabPage',
};

/// Authenticated kullanıcının işi olmayan ekranlar — login/signup/recovery.
const _authOnlyEntryRoutes = <String>{
  '/login',
  '/signUp',
  '/forgotPassword',
  '/verificationCode',
};
