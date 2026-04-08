import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../core/error/result.dart';
import '../impl/auth_service.dart';
import 'auth_service_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthService _authService;
  AuthRepositoryImpl({required IAuthService authService})
    : _authService = authService;

  @override
  firebase_auth.User? get currentUser => _authService.currentFirebaseUser;

  @override
  Future<Result<User>> linkAccount(String email, String password) async =>
      await _authService.upgradeAnonymousUser(email: email, password: password);

  @override
  Future<Result<User>> signInAnonymously() async {
    return await _authService.ensureBothSignedIn();
  }

  @override
  Future<Result<void>> signOut() async {
    return await _authService.signOut();
  }

  @override
  Future<Result<User>> signIn({
    required String email,
    required String password,
  }) async {
    print("şuan repo impl desin ");
    return await _authService.signIn(email: email, password: password);
  }

  @override
  Future<Result<User>> signUp({
    required String email,
    required String password,
  }) async {
    return await _authService.signUp(email: email, password: password);
  }

  @override
  Future<Result<User>> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }
}
