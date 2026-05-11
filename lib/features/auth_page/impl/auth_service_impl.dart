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
      if (existing != null) return Ok(AppUser.fromSupabase(existing));

      final response = await _supabase.auth.signInAnonymously();
      final user = response.user;
      if (user == null) return Err(UnknownFailure());
      return Ok(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      return Err(ServerFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure());
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
      if (user == null) return Err(UnknownFailure());
      return Ok(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      // Email confirmation V0.1'de kapalı — bu dal pratikte tetiklenmemeli,
      // defansif olarak tipi koruyoruz. Açıldığında Cubit otomatik
      // resend + AuthOtpPending'e yönlendirebilir.
      if (e.message.contains('email_not_confirmed')) {
        return Err(EmailNotConfirmedFailure(
          message: 'E-posta adresiniz henüz onaylanmamış.',
        ));
      }
      if (e.message.contains('Invalid login credentials')) {
        return Err(ServerFailure(
          message: 'E-posta veya şifre hatalı.',
        ));
      }
      return Err(ServerFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure());
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
      if (user == null) return Err(UnknownFailure());
      return Ok(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      if (e.message.contains('User already registered') ||
          e.message.contains('already been registered')) {
        return Err(ServerFailure(
          message: 'Bu e-posta adresi zaten kullanımda.',
        ));
      }
      if (e.message.contains('Password should be at least')) {
        return Err(ValidationFailure(
          message: 'Şifre en az 6 karakter olmalı.',
        ));
      }
      if (e.message.contains('invalid_email') ||
          e.message.toLowerCase().contains('invalid email')) {
        return Err(ValidationFailure(
          message: 'Geçersiz e-posta adresi.',
        ));
      }
      return Err(ServerFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure());
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
        return Err(ServerFailure());
      }
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      final user = response.user;
      if (user == null) return Err(UnknownFailure());
      return Ok(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      return Err(ServerFailure(message: e.message));
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return Err(UnknownFailure());
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
      if (user == null) return Err(UnknownFailure());
      return Ok(AppUser.fromSupabase(user));
    } on AuthException catch (e) {
      if (e.message.contains('User already registered') ||
          e.message.contains('already been registered') ||
          e.message.contains('email_exists')) {
        return Err(ServerFailure(
          message: 'Bu e-posta adresi zaten kullanımda.',
        ));
      }
      if (e.message.contains('Password should be at least')) {
        return Err(ValidationFailure(
          message: 'Şifre en az 6 karakter olmalı.',
        ));
      }
      return Err(ServerFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure());
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
      return const Ok(null);
    } on AuthException catch (e) {
      return Err(ServerFailure(message: e.message));
    } catch (e) {
      debugPrint('signOut error: $e');
      return Err(UnknownFailure());
    }
  }
}
