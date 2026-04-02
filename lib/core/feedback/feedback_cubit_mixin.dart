import 'package:flutter_bloc/flutter_bloc.dart';
import '../error/failure.dart';
import '../error/result.dart';
import 'app_feedback.dart';

abstract interface class HasFeedback {
  AppFeedback? get feedback;
  HasFeedback withFeedback(AppFeedback? feedback);
}

mixin FeedbackCubitMixin<S extends HasFeedback> on Cubit<S> {
  void emitFeedback(AppFeedback feedback) {
    emit(state.withFeedback(feedback) as S);
  }

  void clearFeedback() {
    if (state.feedback == null) return;
    emit(state.withFeedback(null) as S);
  }

  Future<void> handleResult<T>(
    Result<T> result, {
    String? successMessage,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    result.when(
      onSuccess: (data) {
        onSuccess?.call(data);
        if (successMessage != null) {
          emitFeedback(SuccessFeedback(successMessage));
        }
      },
      onError: (failure) {
        onError?.call(failure);
        emitFeedback(ErrorFeedback.fromFailure(failure));
      },
    );
  }
}
