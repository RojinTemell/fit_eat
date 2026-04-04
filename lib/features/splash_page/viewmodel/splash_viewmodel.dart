import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth_page/repo/auth_service_repository.dart';

// Bu viewmodel da sadece signed in ayarı önemli olduğu için bir class yerine bool değer tuttuk
class SplashViewmodel extends Cubit<bool> {
  SplashViewmodel(this._authRepository) : super(false) {
    init();
  }
  final IAuthRepository _authRepository;
  // Future<void> init() async {
  //   // SplashViewmodel'da yaptığın işlemleri buraya alabilirsin
  //   await _authRepository.signInAnonymously();
  //   // ... diğer kontroller
  //   emit(true);
  //   // Sonuca göre Authenticated veya Unauthenticated state'i emit et
  // }
  Future<void> init() async {
    print("Splash süreci başladı...");
    // Önce mevcut kullanıcıyı kontrol et
    final user = _authRepository.currentUser;

    if (user == null) {
      print("Kayıtlı değil");
      // Kayıtlı değilse anonim giriş yap
      await _authRepository.signInAnonymously();
    } else if (user.isAnonymous) {
      print("Anonim");
    } else {
      print("Kullanıcı kayıtlı: ${user.email}");
    }

    emit(true);
  }
}
