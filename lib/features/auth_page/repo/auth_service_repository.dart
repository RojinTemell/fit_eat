import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/error/result.dart';

abstract interface class IAuthRepository {
  firebase_auth.User? get currentUser;
  Future<Result<User>> signInAnonymously();
  Future<Result<User>> linkAccount(String email, String password);
  Future<Result<User>> signIn({
    required String email,
    required String password,
  });
  Future<Result<User>> signUp({
    required String email,
    required String password,
  });
  Future<Result<void>> signOut();
  Future<Result<User>> signInWithGoogle();
}
