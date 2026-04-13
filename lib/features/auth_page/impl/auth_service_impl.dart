import 'package:fit_eat/features/auth_page/impl/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../model/app_user.dart';

final class AuthServiceImpl implements IAuthService {
  AuthServiceImpl({required SupabaseClient supabaseClient})
      : _supabase = supabaseClient;

  final SupabaseClient _supabase;

  @override
  AppUser? get currentUser {
    final user = _supabase.auth.currentUser;
    return user != null ? AppUser.fromSupabase(user) : null;
  }

  // ─── ANONYMOUS ───────────────────────────────────────────────────────────

  @override
  Future<Result<AppUser>> signInAnonymously() async {
    try {
      final existing = _supabase.auth.currentUser;
      if (existing != null) return Success(AppUser.fromSupabase(existing));

      final response = await _supabase.auth.signInAnonymously();
      final user = response.user;
      if (user == null) return const Error(UnknownFailure());
      return Success(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      return Error(ServerFailure(e.message));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // ─── SIGN IN ─────────────────────────────────────────────────────────────

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) return const Error(UnknownFailure());
      return Success(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      final msg = e.message.contains('email_not_confirmed')
          ? 'E-posta adresiniz henüz onaylanmamış. Lütfen gelen kutunuzu kontrol edin.'
          : e.message.contains('Invalid login credentials')
              ? 'E-posta veya şifre hatalı.'
              : e.message;
      return Error(ServerFailure(msg));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // ─── SIGN UP ─────────────────────────────────────────────────────────────

  @override
  Future<Result<AppUser>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) return const Error(UnknownFailure());
      return Success(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      final msg = e.message.contains('User already registered')
          ? 'Bu e-posta adresi zaten kullanımda.'
          : e.message;
      return Error(ServerFailure(msg));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // ─── GOOGLE ──────────────────────────────────────────────────────────────
  // google_sign_in 7.x API:
  //   - Singleton: GoogleSignIn.instance (initialized in main.dart)
  //   - Sign in:   GoogleSignIn.instance.authenticate()
  //   - Token:     account.authentication.idToken

  @override
  Future<Result<AppUser>> signInWithGoogle() async {
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        return const Error(
          ServerFailure('Google kimlik doğrulaması başarısız.'),
        );
      }
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      final user = response.user;
      if (user == null) return const Error(UnknownFailure());
      return Success(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      return Error(ServerFailure(e.message));
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return const Error(UnknownFailure());
    }
  }

  // ─── UPGRADE ANONYMOUS ───────────────────────────────────────────────────

  @override
  Future<Result<AppUser>> upgradeAnonymousUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(email: email, password: password),
      );
      final user = response.user;
      if (user == null) return const Error(UnknownFailure());
      return Success(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      return Error(ServerFailure(e.message));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // ─── SIGN OUT ────────────────────────────────────────────────────────────

  @override
  Future<Result<void>> signOut() async {
    try {
      await Future.wait([
        _supabase.auth.signOut(),
        GoogleSignIn.instance.signOut(),
      ]);
      return const Success(null);
    } on AuthException catch (e) {
      return Error(ServerFailure(e.message));
    } catch (e) {
      debugPrint('signOut error: $e');
      return const Error(UnknownFailure());
    }
  }
}
