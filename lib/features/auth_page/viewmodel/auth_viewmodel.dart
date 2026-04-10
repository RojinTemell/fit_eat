import '../../../core/feedback/feedback_listener.dart';
import '../model/app_user.dart';
import '../repo/auth_service_repository.dart';
import '../state/auth_state.dart';

class AuthViewmodel extends FeedbackCubit<AuthState> {
  final IAuthRepository _repo;

  AuthViewmodel(this._repo) : super(const AuthState(isLoading: false));

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _repo.currentUser;
      if (user != null) {
        emit(
          state.copyWith(
            user: user,
            isLoading: false,
            status: user.isAnonymous
                ? AuthStatus.anonymous
                : AuthStatus.authenticated,
          ),
        );
      } else {
        emit(
          state.copyWith(isLoading: false, status: AuthStatus.unauthenticated),
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
    final result = await _repo.signIn(email: email, password: password);
    await handleResult(
      result,
      onSuccess: (user) => emit(
        state.copyWith(
          user: user,
          isLoading: false,
          status: AuthStatus.authenticated,
        ),
      ),
      onError: (_) => emit(state.copyWith(isLoading: false)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isLoading: true));
    final result = await _repo.signInWithGoogle();
    await handleResult(
      result,
      onSuccess: (user) => emit(
        state.copyWith(
          user: user,
          isLoading: false,
          status: AuthStatus.authenticated,
        ),
      ),
      onError: (_) => emit(state.copyWith(isLoading: false)),
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true));

    final currentUser = _repo.currentUser;
    final isAnonymous = currentUser?.isAnonymous ?? false;

    final result = isAnonymous
        ? await _repo.linkAccount(email, password)
        : await _repo.signUp(email: email, password: password);

    await handleResult(
      result,
      onSuccess: (user) => emit(
        state.copyWith(
          user: user,
          isLoading: false,
          status: AuthStatus.authenticated,
        ),
      ),
      onError: (_) => emit(state.copyWith(isLoading: false)),
    );
  }

  Future<void> checkAuth() async {
    emit(state.copyWith(isLoading: true));
    final result = await _repo.signInAnonymously();
    await handleResult(
      result,
      onSuccess: (user) => emit(
        state.copyWith(
          user: user,
          isLoading: false,
          status: AuthStatus.anonymous,
        ),
      ),
      onError: (_) =>
          emit(state.copyWith(isLoading: false, status: AuthStatus.anonymous)),
    );
  }

  Future<void> upgradeToPermanent(String email, String password) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repo.linkAccount(email, password);
    await handleResult(
      result,
      successMessage: 'Hesabınız kalıcı hale getirildi.',
      onSuccess: (user) => emit(
        state.copyWith(
          user: user,
          isLoading: false,
          status: AuthStatus.authenticated,
        ),
      ),
      onError: (_) => emit(state.copyWith(isLoading: false)),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));
    final result = await _repo.signOut();
    await handleResult(
      result,
      onSuccess: (_) => emit(
        state.copyWith(
          user: null,
          isLoading: false,
          status: AuthStatus.unauthenticated,
        ),
      ),
      onError: (_) => emit(state.copyWith(isLoading: false)),
    );
  }
}
