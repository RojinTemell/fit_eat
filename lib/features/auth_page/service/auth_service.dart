import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final supabase.SupabaseClient _supabase = supabase.Supabase.instance.client;
  // Firebase Authentication
  Future<firebase_auth.User> ensureFirebaseSignedIn() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return user;
    }
    final credential = await _firebaseAuth.signInAnonymously();
    return credential.user!;
  }

  firebase_auth.User? get currentFirebaseUser => _firebaseAuth.currentUser;

  bool get isFirebaseAnonymous =>
      _firebaseAuth.currentUser?.isAnonymous ?? false;

  // Supabase Authentication
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
  Future<void> ensureBothSignedIn() async {
    await ensureFirebaseSignedIn();
    await ensureSupabaseSignedIn();
  }

  // Çıkış yap
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _supabase.auth.signOut();
  }

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
