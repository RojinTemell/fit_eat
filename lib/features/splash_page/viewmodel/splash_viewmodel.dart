import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth_page/service/auth_service.dart';

// Bu viewmodel da sadece signed in ayarı önemli olduğu için bir class yerine bool değer tuttuk
class SplashViewmodel extends Cubit<bool> {
  SplashViewmodel(this.authService) : super(false) {
    init();
  }
  final AuthService authService;
  Future<void> init() async {
    await authService.ensureSignedIn();
    emit(true);
  }
}
