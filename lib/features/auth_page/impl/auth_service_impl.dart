import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fit_eat/features/auth_page/impl/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../model/app_user.dart';

final class AuthServiceImpl implements IAuthService {
  AuthServiceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required supabase.SupabaseClient supabaseClient,
  })  : _firebaseAuth = firebaseAuth,
        _supabase = supabaseClient;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final supabase.SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null ? AppUser.fromFirebase(user) : null;
  }

  // ─── ANONYMOUS ───────────────────────────────────────────────────────────

  @override
  Future<Result<AppUser>> signInAnonymously() async {
    try {
      final firebaseResult = await _ensureFirebaseSignedIn();
      if (firebaseResult.isError) return Error(firebaseResult.failureOrNull!);

      final supabaseResult = await _ensureSupabaseSignedIn();
      if (supabaseResult.isError) {
        await signOut();
        return Error(supabaseResult.failureOrNull!);
      }

      return firebaseResult;
    } catch (e) {
      await signOut();
      return const Error(UnknownFailure());
    }
  }

  Future<Result<AppUser>> _ensureFirebaseSignedIn() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) return Success(AppUser.fromFirebase(user));
      final credential = await _firebaseAuth.signInAnonymously();
      return Success(AppUser.fromFirebase(credential.user!));
    } on firebase_auth.FirebaseException catch (e) {
      return Error(ServerFailure(e.message ?? 'Firebase hatası'));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  Future<Result<void>> _ensureSupabaseSignedIn() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) return const Success(null);
      await _supabase.auth.signInAnonymously();
      return const Success(null);
    } on supabase.AuthException catch (e) {
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
      final results = await Future.wait([
        _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password),
        _supabase.auth.signInWithPassword(email: email, password: password),
      ]);

      final fbUser =
          (results[0] as firebase_auth.UserCredential).user!;
      return Success(AppUser.fromFirebase(fbUser));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Error(ServerFailure(e.message ?? 'Giriş yapılamadı'));
    } on supabase.AuthException catch (e) {
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
      final fbCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _supabase.auth.signUp(email: email, password: password);
      return Success(AppUser.fromFirebase(fbCredential.user!));
    } on firebase_auth.FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'email-already-in-use' => 'Bu e-posta adresi zaten kullanımda.',
        'weak-password' => 'Şifre çok zayıf.',
        _ => e.message ?? 'Kayıt sırasında bir hata oluştu.',
      };
      return Error(ServerFailure(msg));
    } on supabase.AuthException catch (e) {
      return Error(ServerFailure('Veri tabanı kaydı sırasında bir sorun oluştu: ${e.message}'));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // ─── GOOGLE ──────────────────────────────────────────────────────────────

  @override
  Future<Result<AppUser>> signInWithGoogle() async {
    try {
      final userCredential =
          await _firebaseAuth.signInWithProvider(firebase_auth.GoogleAuthProvider());
      return Success(AppUser.fromFirebase(userCredential.user!));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return _mapFirebaseError(e);
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
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null || !currentUser.isAnonymous) {
        return Error(ServerFailure('Kullanıcı bulunamadı veya anonim değil.'));
      }

      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final userCredential = await currentUser.linkWithCredential(credential);
      await _supabase.auth.updateUser(
        supabase.UserAttributes(email: email, password: password),
      );

      return Success(AppUser.fromFirebase(userCredential.user!));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Error(ServerFailure(e.message ?? 'Bir Firebase hatası oluştu.'));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // ─── SIGN OUT ────────────────────────────────────────────────────────────

  @override
  Future<Result<void>> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _supabase.auth.signOut(),
      ]);
      return const Success(null);
    } catch (e) {
      debugPrint('signOut error: $e');
      return const Error(UnknownFailure());
    }
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────

  Result<AppUser> _mapFirebaseError(firebase_auth.FirebaseAuthException e) {
    final msg = switch (e.code) {
      'account-exists-with-different-credential' =>
        'Bu e-posta başka bir yöntemle kayıtlı.',
      'user-disabled' => 'Bu hesap devre dışı bırakıldı.',
      'network-request-failed' => 'İnternet bağlantısı yok.',
      'popup-closed-by-user' || 'canceled' => 'Giriş iptal edildi.',
      _ => e.message ?? 'Bir hata oluştu.',
    };
    return Error(ServerFailure(msg));
  }
}
