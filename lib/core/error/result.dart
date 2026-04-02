import 'package:fit_eat/core/error/failure.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

extension ResultX<T> on Result<T> {
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      Error<T>(:final failure) => onError(failure),
    };
  }

  /// Sadece başarı durumuna ihtiyaç varsa; hata görmezden gelinir.
  void ifSuccess(void Function(T data) action) {
    if (this case Success<T>(:final data)) action(data);
  }

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    Error<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Error<T>(:final failure) => failure,
    Success<T>() => null,
  };
}
