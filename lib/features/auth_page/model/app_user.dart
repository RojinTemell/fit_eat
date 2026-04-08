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

  bool get isGuest => status == AuthStatus.anonymous;
}
