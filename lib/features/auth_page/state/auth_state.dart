import 'package:equatable/equatable.dart';

import '../../../core/feedback/app_feedback.dart';
import '../../../core/feedback/feedback_cubit_mixin.dart';
import '../model/app_user.dart';

class AuthState extends Equatable implements HasFeedback {
  const AuthState({
    this.user,
    required this.isLoading,
    this.feedback,
    this.status = AuthStatus.initial,
  });

  final AppUser? user;
  final bool isLoading;
  final AuthStatus status;

  @override
  final AppFeedback? feedback;

  @override
  AuthState withFeedback(AppFeedback? feedback) => copyWith(feedback: feedback);

  @override
  List<Object?> get props => [user, isLoading, feedback, status];

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    Object? feedback = _absent,
    AuthStatus? status,
  }) => AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        feedback: identical(feedback, _absent)
            ? this.feedback
            : feedback as AppFeedback?,
        status: status ?? this.status,
      );
}

const Object _absent = Object();
