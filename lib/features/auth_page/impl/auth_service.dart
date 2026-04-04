import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract interface class IAuthService {
  firebase_auth.User? get currentFirebaseUser;
  Future<supabase.User> ensureSupabaseSignedIn();
  Future<firebase_auth.User> ensureFirebaseSignedIn();
  Future<firebase_auth.User> ensureBothSignedIn();
  Future<void> signOut();
  Future<void> upgradeAnonymousUser({
    required String email,
    required String password,
  });
}
