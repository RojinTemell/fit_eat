import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

enum AuthStatus {
  initial, // Henüz kontrol edilmedi (Splash aşaması)
  authenticated, // Giriş yapmış kullanıcı
  anonymous, // Misafir kullanıcı
  unauthenticated, // Giriş yapmamış/Çıkış yapmış
}

class AppUser {
  final String uid;
  final String? email;
  final AuthStatus status;

  const AppUser({required this.uid, required this.status, this.email});

  bool get isAnonymous => status == AuthStatus.anonymous;
  bool get isGuest => isAnonymous;

  factory AppUser.fromFirebase(firebase_auth.User user) => AppUser(
        uid: user.uid,
        email: user.email,
        status:
            user.isAnonymous ? AuthStatus.anonymous : AuthStatus.authenticated,
      );
}
