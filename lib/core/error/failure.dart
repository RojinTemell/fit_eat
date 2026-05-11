import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String? message;
  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

final class ServerFailure extends Failure {
  final String? code;
  const ServerFailure({super.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({super.message});
}

/// Sign-in denenince Supabase `email_not_confirmed` hatası fırlatırsa
/// bu Failure dönülür. Cubit bunu özel olarak yakalar; otomatik
/// resend OTP + AuthOtpPending'e yönlendirir.
final class EmailNotConfirmedFailure extends Failure {
  const EmailNotConfirmedFailure({super.message});
}

class FailureMessageMapper {
  FailureMessageMapper._();

  static String mapFailureToMessage(Failure failure) {
    final raw = failure.message;
    if (raw != null && raw.isNotEmpty) return raw;

    return switch (failure) {
      NetworkFailure() => "İnternet bağlantısı yok",
      ServerFailure() => "Sunucu hatası oluştu",
      UnauthorizedFailure() => "Yetki hatası",
      ValidationFailure() => "Geçersiz veri girdiniz",
      EmailNotConfirmedFailure() =>
        "E-posta adresiniz henüz doğrulanmadı. Yeni kod gönderildi.",
      UnknownFailure() => "Bir hata oluştu",
    };
  }
}

extension FailureExtension on Failure {
  String get localizedMessage =>
      FailureMessageMapper.mapFailureToMessage(this);
}
