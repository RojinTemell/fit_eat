import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract interface class IAuthRepository {
  firebase_auth.User? get currentUser;
  Future<firebase_auth.User> signInAnonymously();
  Future<void> linkAccount(String email, String password);
  Future<firebase_auth.User> signIn({
    required String email,
    required String password,
  });
  Future<firebase_auth.User> signUp({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<firebase_auth.User?> signInWithGoogle();
}
