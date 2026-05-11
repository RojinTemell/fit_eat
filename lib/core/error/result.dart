import 'package:equatable/equatable.dart';
import 'package:fit_eat/core/error/failure.dart';

sealed class Result<T> extends Equatable {
  const Result();
}

final class Ok<T> extends Result<T> {
  final T data;
  const Ok(this.data);

  @override
  List<Object?> get props => [data];
}

final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);

  @override
  List<Object?> get props => [failure];
}

extension ResultX<T> on Result<T> {
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    return switch (this) {
      Ok<T>(:final data) => onSuccess(data),
      Err<T>(:final failure) => onError(failure),
    };
  }

  /// Sadece başarı durumuna ihtiyaç varsa; hata görmezden gelinir.
  void ifSuccess(void Function(T data) action) {
    if (this case Ok<T>(:final data)) action(data);
  }

  bool get isSuccess => this is Ok<T>;
  bool get isError => this is Err<T>;

  T? get dataOrNull => switch (this) {
    Ok<T>(:final data) => data,
    Err<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Err<T>(:final failure) => failure,
    Ok<T>() => null,
  };
}
