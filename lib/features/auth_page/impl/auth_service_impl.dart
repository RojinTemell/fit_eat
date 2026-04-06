import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_eat/features/auth_page/impl/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

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
  // Firebase Authentication Anonymous
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

  // Supabase Authentication Anonymous
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
      final results = await Future.wait([
        ensureFirebaseSignedIn(),
        ensureSupabaseSignedIn(),
      ]);
      return results[0] as firebase_auth.User;
    } catch (e) {
      await signOut();
      rethrow;
    }
  }

  // Çıkış yap
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
  }

  // update user firebase
  @override
  Future<void> upgradeAnonymousUser({
    required String email,
    required String password,
  }) async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null && firebaseUser.isAnonymous) {
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await firebaseUser.linkWithCredential(credential);
    }

    await _supabase.auth.updateUser(
      supabase.UserAttributes(email: email, password: password),
    );
  }

  // Firebase sign in with email
  @override
  Future<firebase_auth.User> signIn({
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
      return fbUser!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Firebase'e özgü hatalar (Yanlış şifre, kullanıcı bulunamadı vb.)
      print("Firebase Hatası: ${e.code}");
      throw Exception(e.message ?? "Firebase kimlik doğrulama hatası.");
    } catch (e) {
      // Supabase hataları veya diğer genel hatalar
      final errorString = e.toString();
      print("Hata detaylı döküm: $errorString");

      if (errorString.contains('email_not_confirmed')) {
        throw Exception(
          "E-posta adresiniz henüz onaylanmamış. Lütfen gelen kutunuzu kontrol edin.",
        );
      } else if (errorString.contains('Invalid login credentials')) {
        throw Exception("E-posta veya şifre hatalı.");
      }

      // Diğer beklenmedik hatalar için
      throw Exception("Giriş yapılırken bir sorun oluştu: $e");
    }
  }

  // Firebase sign up with email
  @override
  Future<firebase_auth.User> signUp({
    required String email,
    required String password,
  }) async {
    print("Kayıt işlemi başlatıldı: $email");

    try {
      // 1. Önce Firebase kaydını yapalım
      final fbCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Firebase başarılı olduysa Supabase kaydını başlatalım
      try {
        await _supabase.auth.signUp(email: email, password: password);
        print("Supabase kaydı başarılı veya onay maili gönderildi.");
      } catch (supabaseError) {
        // Eğer Firebase başarılı olur ama Supabase hata verirse burada yakalarız.
        // İsteğe bağlı: Burada Firebase kullanıcısını silebilirsin (Rollback).
        print("Supabase Kayıt Hatası: $supabaseError");
        throw Exception("Veri tabanı kaydı sırasında bir sorun oluştu.");
      }

      print("Kayıt işlemi tamamlandı.");
      return fbCredential.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Firebase'e özgü hatalar (Zayıf şifre, zaten kullanımda olan e-posta vb.)
      print("Firebase Kayıt Hatası: ${e.code}");
      if (e.code == 'email-already-in-use') {
        throw Exception("Bu e-posta adresi zaten kullanımda.");
      } else if (e.code == 'weak-password') {
        throw Exception("Şifre çok zayıf.");
      }
      throw Exception(e.message ?? "Kayıt sırasında bir hata oluştu.");
    } catch (e) {
      // Beklenmedik diğer hatalar
      print("Beklenmedik Kayıt Hatası: $e");
      throw Exception("Sistem hatası: $e");
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithProvider(GoogleAuthProvider());

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    } catch (e) {
      throw Exception('Google Sign-In başarısız: $e');
    }
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'Bu e-posta başka bir yöntemle kayıtlı.';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakıldı.';
      case 'network-request-failed':
        return 'İnternet bağlantısı yok.';
      case 'popup-closed-by-user':
      case 'canceled':
        return 'Giriş iptal edildi.';
      default:
        return e.message ?? 'Bir hata oluştu.';
    }
  }
}
