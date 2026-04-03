import '../../domain/entities/app_user.dart';
import '../../service/auth_service.dart';

class AuthRepositoryImpl {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  // Mevcut Firebase/Supabase durumuna göre kullanıcıyı döner
  Future<AppUser> getActiveUser() async {
    final fUser = _authService.currentFirebaseUser;
    
    if (fUser == null) {
      // Eğer hiç oturum yoksa anonim başlat
      final anon = await _authService.ensureBothSignedIn(); 
      return AppUser(uid: anon.uid, status: AuthStatus.anonymous);
    }

    return AppUser(
      uid: fUser.uid,
      email: fUser.email,
      status: fUser.isAnonymous ? AuthStatus.anonymous : AuthStatus.authenticated,
      
    );
  }

  // Anonim hesabı gerçeğe dönüştür (Data kaybı olmadan!)
  Future<AppUser> linkAccount(String email, String password) async {
    await _authService.upgradeAnonymousUser(email: email, password: password);
    return getActiveUser();
  }
}