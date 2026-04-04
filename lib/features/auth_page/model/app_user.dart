enum AuthStatus { anonymous, authenticated, unauthenticated }

class AppUser {
  final String uid;
  final String? email;
  final AuthStatus status;

  const AppUser({required this.uid, required this.status, this.email});

  bool get isGuest => status == AuthStatus.anonymous;
}
