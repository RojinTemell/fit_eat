import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../impl/auth_service.dart';
import 'auth_service_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthService _authService;
  AuthRepositoryImpl({required IAuthService authService})
    : _authService = authService;

  @override
  firebase_auth.User? get currentUser => _authService.currentFirebaseUser;

  @override
  Future<void> linkAccount(String email, String password) async {
    await _authService.upgradeAnonymousUser(email: email, password: password);
  }

  @override
  Future<User> signInAnonymously() async {
    return await _authService.ensureBothSignedIn();
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<firebase_auth.User> signIn({
    required String email,
    required String password,
  }) async {
    print("şuan repo impl desin ");
    final User user = await _authService.signIn(
      email: email,
      password: password,
    );
    return user;
  }

  @override
  Future<firebase_auth.User> signUp({
    required String email,
    required String password,
  }) async {
    final User user = await _authService.signUp(
      email: email,
      password: password,
    );
    return user;
  }

  @override
  Future<firebase_auth.User?> signInWithGoogle() async {
    final firebase_auth.User? user = await _authService.signInWithGoogle();
    return user;
  }
}
