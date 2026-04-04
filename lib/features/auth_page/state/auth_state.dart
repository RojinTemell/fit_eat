import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState extends Equatable {
  const AuthState({this.user, required this.isLoading});
  final User? user;
  final bool isLoading;
  @override
  List<Object?> get props => [user, isLoading];
  AuthState copyWith({User? user, bool? isLoading}) => AuthState(
    user: user ?? this.user,
    isLoading: isLoading ?? this.isLoading,
  );
}
