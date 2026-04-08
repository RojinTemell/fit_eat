import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_eat/features/auth_page/impl/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';

final class AuthServiceImpl implements IAuthService {
  AuthServiceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required supabase.SupabaseClient supabaseClient,
  }) : _firebaseAuth = firebaseAuth,
       _supabase = supabaseClient;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final supabase.SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  firebase_auth.User? get currentFirebaseUser => _firebaseAuth.currentUser;
  supabase.User? get currentSupabaseUser => _supabase.auth.currentUser;

  bool get isFirebaseAnonymous =>
      _firebaseAuth.currentUser?.isAnonymous ?? false;

  bool get isSupabaseAnonymous {
    final user = _supabase.auth.currentUser;
    return user?.isAnonymous ?? false;
  }

  // Firebase Authentication Anonymous
  @override
  Future<Result<User>> ensureFirebaseSignedIn() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return Success(user);
      }
      final credential = await _firebaseAuth.signInAnonymously();
      return Success(credential.user!);
    } on FirebaseException catch (e) {
      debugPrint(
        '[CreateRecipeService] Firebase error: ${e.code} ${e.message}',
      );
      return Error(ServerFailure(e.message ?? 'Sunucu hatası'));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // Supabase Authentication Anonymous
  @override
  Future<Result<supabase.User>> ensureSupabaseSignedIn() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        return Success(user);
      }
      final response = await _supabase.auth.signInAnonymously();
      return Success(response.user!);
    } on FirebaseException catch (e) {
      debugPrint(
        '[CreateRecipeService] Firebase error: ${e.code} ${e.message}',
      );
      return Error(ServerFailure(e.message ?? 'Sunucu hatası'));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // Her ikisini birden sağla
  @override
  Future<Result<User>> ensureBothSignedIn() async {
    try {
      final results = await Future.wait([
        ensureFirebaseSignedIn(),
        ensureSupabaseSignedIn(),
      ]);
      return results[0] as Result<User>;
    } catch (e) {
      await signOut();
      rethrow;
    }
  }

  // Çıkış yap
  @override
  Future<Result<void>> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
    return Success(null);
  }

  // update user firebase
  @override
  Future<Result<User>> upgradeAnonymousUser({
    required String email,
    required String password,
  }) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser != null && currentUser.isAnonymous) {
        final credential = firebase_auth.EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        final userCredential = await currentUser.linkWithCredential(credential);
        await _supabase.auth.updateUser(
          supabase.UserAttributes(email: email, password: password),
        );

        if (userCredential.user != null) {
          return Success(userCredential.user!);
        }
      }
      return Error(ServerFailure("Kullanıcı bulunamadı veya anonim değil."));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Error(ServerFailure(e.message ?? "Bir Firebase hatası oluştu."));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  // Firebase sign in with email
  @override
  Future<Result<User>> signIn({
    required String email,
    required String password,
  }) async {
    print("Giriş işlemi başlatıldı...");

    try {
      // Future.wait içindeki işlemlerden biri hata alırsa catch bloğuna düşer.
      final results = await Future.wait([
        _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
        _supabase.auth.signInWithPassword(email: email, password: password),
      ]);

      // Eğer buraya ulaştıysa iki tarafta da giriş başarılıdır.
      final fbUser = (results[0] as firebase_auth.UserCredential).user;

      print("Giriş başarılı: Hem Firebase hem Supabase doğrulandı.");

      return Success(fbUser!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Error(ServerFailure(e.message ?? 'Öneri gönderilemedi'));
    } catch (e) {
      final errorString = e.toString();
      if (errorString.contains('email_not_confirmed')) {
        Error(
          ServerFailure(
            "E-posta adresiniz henüz onaylanmamış. Lütfen gelen kutunuzu kontrol edin.",
          ),
        );
      } else if (errorString.contains('Invalid login credentials')) {
        Exception("E-posta veya şifre hatalı.");
      }

      return Error(UnknownFailure());
    }
  }

  // Firebase sign up with email
  @override
  Future<Result<User>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final fbCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Firebase başarılı olduysa Supabase kaydını başlatalım
      try {
        await _supabase.auth.signUp(email: email, password: password);
        print("Supabase kaydı başarılı veya onay maili gönderildi.");
      } catch (supabaseError) {
        print("Supabase Kayıt Hatası: $supabaseError");
        return Error(
          ServerFailure("Veri tabanı kaydı sırasında bir sorun oluştu."),
        );
      }

      print("Kayıt işlemi tamamlandı.");
      return Success(fbCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Error(ServerFailure("Bu e-posta adresi zaten kullanımda."));
      } else if (e.code == 'weak-password') {
        return Error(ServerFailure("Şifre çok zayıf."));
      }
      return Error(
        ServerFailure(e.message ?? "Kayıt sırasında bir hata oluştu."),
      );
    } catch (e) {
      return Error(UnknownFailure());
    }
  }

  @override
  Future<Result<User>> signInWithGoogle() async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithProvider(GoogleAuthProvider());

      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    } catch (e) {
      throw Exception('Google Sign-In başarısız: $e');
    }
  }

  Result<void> _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return Error(ServerFailure('Bu e-posta başka bir yöntemle kayıtlı.'));

      case 'user-disabled':
        return Error(ServerFailure('Bu hesap devre dışı bırakıldı.'));

      case 'network-request-failed':
        return Error(ServerFailure('İnternet bağlantısı yok.'));

      case 'popup-closed-by-user':
      case 'canceled':
        return Error(ServerFailure('Giriş iptal edildi.'));
      default:
        return Error(ServerFailure(e.message ?? 'Bir hata oluştu.'));
    }
  }
}
