import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/auth_implements_impl.dart';
import '../state/auth_state.dart';

class AuthViewmodel extends Cubit<AuthState> {
  final AuthRepositoryImpl _repo;

  AuthViewmodel(this._repo) : super(AuthInitial());

  // App açıldığında çağrılır
  Future<void> checkAuth() async {
    emit(AuthLoading());
    try {
      final user = await _repo.getActiveUser();
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError("Bağlantı hatası oluştu."));
    }
  }

  // Kayıt ol butonuna basıldığında çağrılır
  Future<void> upgradeToPermanent(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _repo.linkAccount(email, password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError("Kayıt başarısız: ${e.toString()}"));
    }
  }
}
