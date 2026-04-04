import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fit_eat/features/auth_page/impl/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final class AuthServiceImpl implements IAuthService {
  AuthServiceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required supabase.SupabaseClient supabaseClient,
  }) : _firebaseAuth = firebaseAuth,
       _supabase = supabaseClient;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final supabase.SupabaseClient _supabase;

  @override
  firebase_auth.User? get currentFirebaseUser => _firebaseAuth.currentUser;

  @override
  Future<firebase_auth.User> ensureFirebaseSignedIn() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return user;
    }
    final credential = await _firebaseAuth.signInAnonymously();
    return credential.user!;
  }

  bool get isFirebaseAnonymous =>
      _firebaseAuth.currentUser?.isAnonymous ?? false;

  // Supabase Authentication
  @override
  Future<supabase.User> ensureSupabaseSignedIn() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return user;
    }
    final response = await _supabase.auth.signInAnonymously();
    return response.user!;
  }

  supabase.User? get currentSupabaseUser => _supabase.auth.currentUser;

  bool get isSupabaseAnonymous {
    final user = _supabase.auth.currentUser;
    return user?.isAnonymous ?? false;
  }

  // Her ikisini birden sağla
  @override
  Future<firebase_auth.User> ensureBothSignedIn() async {
    try {
      // Performans için paralel çalıştırıyoruz
      final results = await Future.wait([
        ensureFirebaseSignedIn(),
        ensureSupabaseSignedIn(),
      ]);
      return results[0] as firebase_auth.User;
    } catch (e) {
      // Herhangi biri hata verirse ikisini de kapat (Tutarlılık için)
      await signOut();
      rethrow;
    }
  }

  // Çıkış yap
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _supabase.auth.signOut();
  }

  @override
  Future<void> upgradeAnonymousUser({
    required String email,
    required String password,
  }) async {
    // Firebase upgrade
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null && firebaseUser.isAnonymous) {
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await firebaseUser.linkWithCredential(credential);
    }

    // Supabase upgrade
    await _supabase.auth.updateUser(
      supabase.UserAttributes(email: email, password: password),
    );
  }
}
