import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  initial, // Not yet checked (splash phase)
  authenticated, // Signed-in user
  anonymous, // Guest user
  unauthenticated, // Signed out
}

class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final AuthStatus status;

  const AppUser({
    required this.uid,
    required this.status,
    this.email,
    this.displayName,
    this.avatarUrl,
  });

  bool get isAnonymous => status == AuthStatus.anonymous;
  bool get isGuest => isAnonymous;

  factory AppUser.fromSupabase(User user) => AppUser(
        uid: user.id,
        email: user.email,
        displayName: user.userMetadata?['full_name'] as String? ??
            user.userMetadata?['name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        status:
            user.isAnonymous ? AuthStatus.anonymous : AuthStatus.authenticated,
      );
}
