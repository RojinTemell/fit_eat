import 'package:fit_eat/core/error/result.dart';

import '../model/app_user.dart';

abstract interface class IAuthService {
  AppUser? get currentUser;
  Future<Result<AppUser>> signInAnonymously();
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  });
  Future<Result<AppUser>> signUp({
    required String email,
    required String password,
  });
  Future<Result<AppUser>> signInWithGoogle();
  Future<Result<void>> signOut();
  Future<Result<AppUser>> upgradeAnonymousUser({
    required String email,
    required String password,
  });
}
