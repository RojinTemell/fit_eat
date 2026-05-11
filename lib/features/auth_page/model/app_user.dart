import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// FITEAT — Auth katmanının kimlik bilgisi taşıyıcısı.
///
/// `status` field'ı kasıtlı olarak yok: kullanıcının auth durumu
/// (Initial / Unauthenticated / OtpPending / Anonymous / Authenticated)
/// `AuthState` sealed hiyerarşisinde ifade edilir. AppUser sadece kimlik.
class AppUser extends Equatable {
  const AppUser({
    required this.uid,
    required this.isAnonymous,
    this.email,
    this.displayName,
    this.avatarUrl,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? avatarUrl;

  /// Supabase'in `user.isAnonymous` flag'i — anon session ile gerçek session
  /// ayrımı için tek doğru kaynak. AuthState varyantı seçilirken
  /// bu field kontrol edilir.
  final bool isAnonymous;

  factory AppUser.fromSupabase(User user) => AppUser(
        uid: user.id,
        email: user.email,
        displayName: user.userMetadata?['full_name'] as String? ??
            user.userMetadata?['name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        isAnonymous: user.isAnonymous,
      );

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? avatarUrl,
    bool? isAnonymous,
  }) =>
      AppUser(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        isAnonymous: isAnonymous ?? this.isAnonymous,
      );

  @override
  List<Object?> get props => [uid, email, displayName, avatarUrl, isAnonymous];
}
