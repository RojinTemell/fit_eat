import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract interface class IAuthRepository {
  firebase_auth.User? get currentUser;
  Future<firebase_auth.User> signInAnonymously();
  Future<void> linkAccount(String email, String password);
  Future<void> signOut();
}
