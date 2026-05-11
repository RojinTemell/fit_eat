import 'package:equatable/equatable.dart';
import '../../../core/feedback/app_feedback.dart';
import '../../../core/feedback/feedback_cubit_mixin.dart';
import '../model/app_user.dart';

sealed class AuthState extends Equatable implements HasFeedback {
  const AuthState({this.feedback});

  @override
  final AppFeedback? feedback;
  @override
  AuthState withFeedback(AppFeedback? feedback);

  @override
  List<Object?> get props => [feedback];
}

/// Uygulama açıldı, AuthCubit._bootstrap henüz tamamlanmadı.
/// Sadece bir defa görülür: constructor'dan onAuthStateChange'in
/// ilk emit'ine kadar. Splash bu state'te spinner gösterir; bir daha
/// bu state'e dönülmez (transition kuralı, type sistemiyle değil
/// Cubit kontratıyla zorlanır).
final class AuthInitial extends AuthState {
  const AuthInitial({super.feedback});

  @override
  AuthInitial withFeedback(AppFeedback? feedback) =>
      AuthInitial(feedback: feedback);

  @override
  List<Object?> get props => [feedback];
}

/// Session yok. Login / sign-up / forgot-password ekranları erişilebilir.
/// MVP'de bu state'e sadece logout ile düşülür; ilk açılışta otomatik
/// AuthAnonymous'a geçiş yapılır.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({
    this.busy = AuthBusy.idle,
    super.feedback,
  });

  final AuthBusy busy;

  AuthUnauthenticated copyWith({
    AuthBusy? busy,
    Object? feedback = _absent,
  }) =>
      AuthUnauthenticated(
        busy: busy ?? this.busy,
        feedback: identical(feedback, _absent)
            ? this.feedback
            : feedback as AppFeedback?,
      );

  @override
  AuthUnauthenticated withFeedback(AppFeedback? feedback) =>
      copyWith(feedback: feedback);

  @override
  List<Object?> get props => [busy, feedback];
}

/// Sign-up tamamlandı, email ile gelen OTP kodu bekleniyor.
/// Router redirect kullanıcıyı /verificationCode dışına bırakmaz.
/// Çıkış: kod doğrulanırsa AuthAuthenticated, iptal edilirse
/// AuthUnauthenticated.
final class AuthOtpPending extends AuthState {
  const AuthOtpPending({
    required this.email,
    this.busy = AuthBusy.idle,
    super.feedback,
  });

  /// Hangi email'e OTP gönderildi — verifyOtp ve resend için lazım.
  final String email;
  final AuthBusy busy;

  AuthOtpPending copyWith({
    String? email,
    AuthBusy? busy,
    Object? feedback = _absent,
  }) =>
      AuthOtpPending(
        email: email ?? this.email,
        busy: busy ?? this.busy,
        feedback: identical(feedback, _absent)
            ? this.feedback
            : feedback as AppFeedback?,
      );

  @override
  AuthOtpPending withFeedback(AppFeedback? feedback) =>
      copyWith(feedback: feedback);

  @override
  List<Object?> get props => [email, busy, feedback];
}

/// Anonim session aktif. user.isAnonymous == true (Cubit kontratı).
/// Uygulama açılışındaki varsayılan state — kullanıcı kayıt olmadan
/// browse edebilsin diye otomatik anon sign-in yapılır.
final class AuthAnonymous extends AuthState {
  const AuthAnonymous({
    required this.user,
    this.busy = AuthBusy.idle,
    super.feedback,
  });

  final AppUser user;
  final AuthBusy busy;

  AuthAnonymous copyWith({
    AppUser? user,
    AuthBusy? busy,
    Object? feedback = _absent,
  }) =>
      AuthAnonymous(
        user: user ?? this.user,
        busy: busy ?? this.busy,
        feedback: identical(feedback, _absent)
            ? this.feedback
            : feedback as AppFeedback?,
      );

  @override
  AuthAnonymous withFeedback(AppFeedback? feedback) =>
      copyWith(feedback: feedback);

  @override
  List<Object?> get props => [user, busy, feedback];
}

/// Gerçek session aktif. user.isAnonymous == false (Cubit kontratı).
/// Bu state'e geçiş yolları:
///   - signIn (email+şifre)
///   - signInWithGoogle
///   - OTP doğrulama tamamlandı (sign-up)
///   - Anon → email/Google linkleme
///   - Şifre sıfırlama tamamlandı
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({
    required this.user,
    this.busy = AuthBusy.idle,
    super.feedback,
  });

  final AppUser user;
  final AuthBusy busy;

  AuthAuthenticated copyWith({
    AppUser? user,
    AuthBusy? busy,
    Object? feedback = _absent,
  }) =>
      AuthAuthenticated(
        user: user ?? this.user,
        busy: busy ?? this.busy,
        feedback: identical(feedback, _absent)
            ? this.feedback
            : feedback as AppFeedback?,
      );

  @override
  AuthAuthenticated withFeedback(AppFeedback? feedback) =>
      copyWith(feedback: feedback);

  @override
  List<Object?> get props => [user, busy, feedback];
}

/// Devam eden auth operation. UI butonları loading state için
/// pattern matching + busy kontrolü yapar:
///
///   final isSigningIn = switch (state) {
///     AuthUnauthenticated(:final busy) => busy == AuthBusy.signingIn,
///     _ => false,
///   };
///
/// Tek bir bool isLoading yerine spesifik enum kullanmamızın sebebi:
/// aynı ekranda birden fazla async iş tetikleyen buton olabilir
/// (Login + Şifremi unuttum), her birinin kendi spinner'ı için.
enum AuthBusy {
  idle,

  /// signInWithPassword
  signingIn,

  /// signUp (yeni hesap; başarı sonrası AuthOtpPending'e geçer)
  signingUp,

  /// Anon → email/Google upgrade (linkIdentity / updateUser)
  linkingIdentity,

  signingOut,

  /// OTP yeniden gönderme (resend butonu)
  sendingOtp,

  /// verifyOtp(type: signup) — kullanıcı kodu girdi
  verifyingOtp,

  /// resetPasswordForEmail — recovery maili gönderiliyor
  sendingPasswordReset,

  /// verifyOtp(type: recovery) + updateUser(password) — yeni şifre seti
  resettingPassword,
}

const Object _absent = Object();
