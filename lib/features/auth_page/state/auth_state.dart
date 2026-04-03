// Equatable kullanarak nesne karşılaştırmasını (==) optimize ediyoruz

import 'package:equatable/equatable.dart';

import '../domain/entities/app_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => []; // Alt sınıflar kendi özelliklerini buraya ekleyecek
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user]; // Sadece user değişirse UI tetiklenir
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message]; // Aynı hata mesajı üst üste gelirse UI sarsılmaz
}
