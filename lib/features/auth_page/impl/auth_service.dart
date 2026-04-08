import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_eat/core/error/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract interface class IAuthService {
  firebase_auth.User? get currentFirebaseUser;
  Future<Result<supabase.User>> ensureSupabaseSignedIn();
  Future<Result<User>> ensureFirebaseSignedIn();
  Future<Result<User>> ensureBothSignedIn();
  Future<Result<User>> signIn({
    required String email,
    required String password,
  });
  Future<Result<User>> signUp({
    required String email,
    required String password,
  });
  Future<Result<User>> signInWithGoogle();
  Future<Result<void>> signOut();
  Future<Result<User>> upgradeAnonymousUser({
    required String email,
    required String password,
  });
}
