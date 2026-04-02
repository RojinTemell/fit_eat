import '../error/failure.dart';

sealed class AppFeedback {
  const AppFeedback();
}

class SuccessFeedback extends AppFeedback {
  final String message;
  const SuccessFeedback(this.message);
}

class ErrorFeedback extends AppFeedback {
  final String message;
  const ErrorFeedback(this.message);

  /// Failure nesnesinden direkt üret — ViewModel'de tekrar tekrar
  /// failure.message yazmak zorunda kalmayız.
  factory ErrorFeedback.fromFailure(Failure failure) =>
      ErrorFeedback(failure.message);
}
