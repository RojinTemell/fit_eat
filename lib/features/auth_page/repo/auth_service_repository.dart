import '../../../core/error/result.dart';
import '../model/app_user.dart';

abstract interface class IAuthRepository {
  AppUser? get currentUser;
  Future<Result<AppUser>> signInAnonymously();
  Future<Result<AppUser>> linkAccount(String email, String password);
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  });
  Future<Result<AppUser>> signUp({
    required String email,
    required String password,
  });
  Future<Result<void>> signOut();
  Future<Result<AppUser>> signInWithGoogle();
}
