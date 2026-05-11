import 'package:equatable/equatable.dart';

import '../model/app_user.dart';

/// FITEAT — Auth katmanı dış event tipi.
///
/// Supabase'in `onAuthStateChange` stream'i Cubit'e doğrudan sızdırılmıyor;
/// AuthServiceImpl Supabase event'ini bu tipe map'liyor. Cubit sadece
/// kendisi için anlamlı 3 olayı görür: signedIn, signedOut, userUpdated.
/// tokenRefreshed ve passwordRecovery sessizce yutulur (servis tarafında
/// filtrelenir).
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthEventSignedIn extends AuthEvent {
  const AuthEventSignedIn(this.user);

  final AppUser user;

  @override
  List<Object?> get props => [user];
}

final class AuthEventSignedOut extends AuthEvent {
  const AuthEventSignedOut();
}

final class AuthEventUserUpdated extends AuthEvent {
  const AuthEventUserUpdated(this.user);

  final AppUser user;

  @override
  List<Object?> get props => [user];
}
