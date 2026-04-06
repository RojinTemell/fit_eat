import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth_page/model/app_user.dart';
import '../../auth_page/repo/auth_service_repository.dart';

// Bu viewmodel da sadece signed in ayarı önemli olduğu için bir class yerine bool değer tuttuk
class SplashViewmodel extends Cubit<AuthStatus> {
  SplashViewmodel(this._authRepository) : super(AuthStatus.unauthenticated) {
    init();
  }
  final IAuthRepository _authRepository;
  Future<void> init() async {
    final user = _authRepository.currentUser;

    if (user == null) {
      await _authRepository.signInAnonymously();
      emit(AuthStatus.anonymous);
    } else if (user.isAnonymous == false) {
      await Future.delayed(Duration(milliseconds: 500));
      emit(AuthStatus.authenticated);
    } else {
      emit(AuthStatus.unauthenticated);
    }
    print(user);
  }
}
