import '../../../core/error/result.dart';
import '../../../core/feedback/app_feedback.dart';
import '../../../core/feedback/feedback_listener.dart';
import '../model/app_user.dart';
import '../repo/auth_service_repository.dart';
import '../state/auth_state.dart';

class AuthViewmodel extends FeedbackCubit<AuthState> {
  final IAuthRepository _repo;

  AuthViewmodel(this._repo) : super(const AuthInitial());

  Future<void> bootstrap() async {
    if (state is! AuthInitial) return;

    final existing = _repo.currentUser;
    if (existing != null) {
      emit(_resolveFromUser(existing));
      return;
    }

    final result = await _repo.signInAnonymously();
    result.when(
      onSuccess: (user) => emit(AuthAnonymous(user: user)),
      onError: (failure) {
        emit(const AuthUnauthenticated());
        emitFeedback(ErrorFeedback.fromFailure(failure));
      },
    );
  }

  AuthState _resolveFromUser(AppUser user) => user.isAnonymous
      ? AuthAnonymous(user: user)
      : AuthAuthenticated(user: user);

  Future<void> signIn({required String email, required String password}) async {
    final current = state;
    if (current is! AuthUnauthenticated && current is! AuthAnonymous) {
      _rejectInvalidAction();
      return;
    }

    _setBusy(current, AuthBusy.signingIn);

    final result = await _repo.signIn(email: email, password: password);
    await handleResult(
      result,
      onSuccess: (user) => emit(AuthAuthenticated(user: user)),
      onError: (_) => _resetIdle(current),
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    final current = state;

    if (current is AuthAnonymous) {
      _setBusy(current, AuthBusy.linkingIdentity);
      final result = await _repo.linkAccount(email, password);
      await handleResult(
        result,
        successMessage: 'Hesabınız oluşturuldu.',
        onSuccess: (user) => emit(AuthAuthenticated(user: user)),
        onError: (_) => _resetIdle(current),
      );
      return;
    }

    if (current is AuthUnauthenticated) {
      _setBusy(current, AuthBusy.signingUp);
      final result = await _repo.signUp(email: email, password: password);
      await handleResult(
        result,
        successMessage: 'Hesabınız oluşturuldu.',
        onSuccess: (user) => emit(AuthAuthenticated(user: user)),
        onError: (_) => _resetIdle(current),
      );
      return;
    }

    _rejectInvalidAction();
  }

  // ──────────────────────────────────────────────────────────────────────
  // GOOGLE SIGN-IN
  // ──────────────────────────────────────────────────────────────────────

  /// AuthUnauthenticated veya AuthAnonymous → AuthAuthenticated.
  /// google_sign_in 7.x: GoogleSignIn.instance.initialize(...) main()
  /// içinde çağrılmış olmalı; aksi halde authenticate() throw eder.
  Future<void> signInWithGoogle() async {
    final current = state;
    if (current is! AuthUnauthenticated && current is! AuthAnonymous) {
      _rejectInvalidAction();
      return;
    }

    _setBusy(current, AuthBusy.signingIn);

    final result = await _repo.signInWithGoogle();
    await handleResult(
      result,
      onSuccess: (user) => emit(AuthAuthenticated(user: user)),
      onError: (_) => _resetIdle(current),
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // LOGOUT
  // ──────────────────────────────────────────────────────────────────────

  /// AuthAnonymous veya AuthAuthenticated → AuthAnonymous (yeni anon).
  ///
  /// MVP davranışı: çıkış sonrası kullanıcı browse'a devam edebilsin diye
  /// AuthUnauthenticated yerine yeni bir anon session başlatılır.
  /// Anon başlatılamazsa fallback AuthUnauthenticated.
  ///
  /// handleResult'u burada success branşı için kullanmıyoruz çünkü
  /// success'ten sonra ikinci bir async iş (yeni anon) var; sonucu
  /// elle pattern match'liyoruz.
  Future<void> logout() async {
    final current = state;
    if (current is! AuthAnonymous && current is! AuthAuthenticated) {
      _rejectInvalidAction();
      return;
    }

    _setBusy(current, AuthBusy.signingOut);

    final signOutResult = await _repo.signOut();
    if (signOutResult is Err<void>) {
      _resetIdle(current);
      emitFeedback(ErrorFeedback.fromFailure(signOutResult.failure));
      return;
    }

    // Sign-out başarılı. Yeni anon başlat.
    final anonResult = await _repo.signInAnonymously();
    anonResult.when(
      onSuccess: (user) {
        emit(AuthAnonymous(user: user));
        emitFeedback(const SuccessFeedback('Çıkış yapıldı.'));
      },
      onError: (_) {
        // Anon başlamadı (config kapalı / network yok) — kullanıcı yine
        // de çıkmış sayılır, fallback AuthUnauthenticated. Feedback'i
        // success olarak veriyoruz (çıkış aksiyonu tamamlandı).
        emit(const AuthUnauthenticated());
        emitFeedback(const SuccessFeedback('Çıkış yapıldı.'));
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // HELPERS
  // ──────────────────────────────────────────────────────────────────────

  /// Aynı varyantta busy alanını güncelle ve önceki feedback'i temizle.
  /// Her varyantın copyWith imzası ayrı olduğu için generic helper
  /// yazmak yerine pattern match yapıyoruz.
  void _setBusy(AuthState current, AuthBusy busy) {
    switch (current) {
      case AuthUnauthenticated():
        emit(current.copyWith(busy: busy, feedback: null));
      case AuthAnonymous():
        emit(current.copyWith(busy: busy, feedback: null));
      case AuthAuthenticated():
        emit(current.copyWith(busy: busy, feedback: null));
      case AuthOtpPending():
        emit(current.copyWith(busy: busy, feedback: null));
      case AuthInitial():
        // AuthInitial busy taşımaz — bu yola düşülmesi programlama hatası.
        break;
    }
  }

  void _resetIdle(AuthState state) {
    switch (state) {
      case AuthUnauthenticated():
        emit(const AuthUnauthenticated());
      case AuthAnonymous(:final user):
        emit(AuthAnonymous(user: user));
      case AuthAuthenticated(:final user):
        emit(AuthAuthenticated(user: user));
      case AuthOtpPending(:final email):
        emit(AuthOtpPending(email: email));
      case AuthInitial():
        emit(const AuthInitial());
    }
  }

  /// Geçersiz state'ten aksiyon çağrıldığında sessizce yutmamak için.
  /// Örnek: AuthInitial'dayken signIn tetiklenirse — bu programlama
  /// hatasıdır, feedback üzerinden UI'a düşürüyoruz ki testte fark edilsin.
  void _rejectInvalidAction() {
    emitFeedback(const ErrorFeedback('Bu işlem şu anda kullanılamaz.'));
  }
}
