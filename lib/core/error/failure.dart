abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super(message: "İnternet bağlantısı yok");
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message: message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super(message: "Oturum süresi doldu");
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super(message: "Beklenmeyen bir hata oluştu");
}
