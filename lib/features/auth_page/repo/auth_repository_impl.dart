import '../../../core/error/result.dart';
import '../impl/auth_service.dart';
import '../model/app_user.dart';
import 'auth_service_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthService _authService;

  AuthRepositoryImpl({required IAuthService authService})
      : _authService = authService;

  @override
  AppUser? get currentUser => _authService.currentUser;

  @override
  Future<Result<AppUser>> signInAnonymously() =>
      _authService.signInAnonymously();

  @override
  Future<Result<AppUser>> linkAccount(String email, String password) =>
      _authService.upgradeAnonymousUser(email: email, password: password);

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) =>
      _authService.signIn(email: email, password: password);

  @override
  Future<Result<AppUser>> signUp({
    required String email,
    required String password,
  }) =>
      _authService.signUp(email: email, password: password);

  @override
  Future<Result<void>> signOut() => _authService.signOut();

  @override
  Future<Result<AppUser>> signInWithGoogle() => _authService.signInWithGoogle();
}
