import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/auth_service_repository.dart';
import '../state/auth_state.dart';

class AuthViewmodel extends Cubit<AuthState> {
  final IAuthRepository _repo;

  AuthViewmodel(this._repo) : super(AuthState(isLoading: false));
  Future<void> init() async {
    emit(state.copyWith(isLoading: true)); // Loading state eklemenizi öneririm
    try {
      final user = _repo.currentUser;
      if (user != null) {
        emit(state.copyWith(user: user, isLoading: false));
      } else {
        await checkAuth();
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> checkAuth() async {
    try {
      final newUser = await _repo.signInAnonymously();
      emit(state.copyWith(user: newUser, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  // Kayıt ol butonuna basıldığında çağrılır
  Future<void> upgradeToPermanent(String email, String password) async {
    await _repo.linkAccount(email, password);
  }

  Future<void> logout() async {
    await _repo.signOut();
  }
}
