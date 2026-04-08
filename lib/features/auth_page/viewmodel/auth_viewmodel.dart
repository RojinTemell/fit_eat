import 'package:fit_eat/features/auth_page/model/app_user.dart';

import '../../../core/feedback/feedback_listener.dart';
import '../repo/auth_service_repository.dart';
import '../state/auth_state.dart';

class AuthViewmodel extends FeedbackCubit<AuthState> {
  final IAuthRepository _repo;

  AuthViewmodel(this._repo) : super(AuthState(isLoading: false));
  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final user = _repo.currentUser;
      if (user != null) {
        // Kullanıcı varsa (Anonim veya Kayıtlı)
        final status = user.isAnonymous
            ? AuthStatus.anonymous
            : AuthStatus.authenticated;
        emit(state.copyWith(user: user, isLoading: false, status: status));
      } else {
        emit(
          state.copyWith(
            user: null,
            isLoading: false,
            status: AuthStatus.unauthenticated,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, status: AuthStatus.unauthenticated),
      );
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _repo.signIn(email: email, password: password);
      await handleResult(
        result,
        // successMessage: 'Giriş Yapıldı',
        onSuccess: (data) => emit(
          state.copyWith(
            user: data,
            isLoading: false,
            status: AuthStatus.authenticated,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, status: AuthStatus.unauthenticated),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _repo.signInWithGoogle();
      await handleResult(
        result,
        // successMessage: 'Giriş Yapılıyor',
        onSuccess: (data) => emit(
          state.copyWith(
            user: data,
            isLoading: false,
            status: AuthStatus.authenticated,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, status: AuthStatus.unauthenticated),
      );
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final currentUser = _repo.currentUser;

      // EĞER KULLANICI ANONİM İSE: Hesabı yükselt (Link)
      if (currentUser != null && currentUser.isAnonymous == true) {
        final result = await _repo.linkAccount(
          email,
          password,
        ); // Mevcut metodun
        await handleResult(
          result,
          // successMessage: 'Hesabınız başarıyla kalıcı hale getirildi',
          onSuccess: (data) => emit(
            state.copyWith(
              user: data,
              isLoading: false,
              status: AuthStatus.authenticated,
            ),
          ),
        );
      }
      // EĞER KULLANICI HİÇ YOKSA (Temiz kurulum): Normal kayıt yap
      else {
        final result = await _repo.signUp(email: email, password: password);
        await handleResult(
          result,
          // successMessage: 'Kayıt oldunuz',
          onSuccess: (data) => emit(
            state.copyWith(
              user: data,
              isLoading: false,
              status: AuthStatus.authenticated,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, status: AuthStatus.unauthenticated),
      );
    }
  }

  Future<void> checkAuth() async {
    try {
      final result = await _repo.signInAnonymously();
      await handleResult(
        result,
        // successMessage: 'Anonim giriş yaptınız',
        onSuccess: (data) => emit(
          state.copyWith(
            user: data,
            isLoading: false,
            status: AuthStatus.anonymous,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, status: AuthStatus.anonymous));
    }
  }

  Future<void> upgradeToPermanent(String email, String password) async {
    final result = await _repo.linkAccount(email, password);
    emit(state.copyWith(status: AuthStatus.authenticated));
    await handleResult(result, successMessage: 'Giriş durumu güncellendi');
  }

  Future<void> logout() async {
    final result = await _repo.signOut();
    await handleResult(
      result,
      //  successMessage: 'Çıkış Yapıldı'
    );
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
