import 'package:dio/dio.dart';
import '../error/failure.dart';

// Failure mapDioError(DioException e) {
//   if (e.type == DioExceptionType.connectionTimeout ||
//       e.type == DioExceptionType.receiveTimeout) {
//     return const NetworkFailure();
//   }

//   if (e.response?.statusCode == 401) {
//     return const UnauthorizedFailure();
//   }

//   if (e.response != null) {
//     return ServerFailure(
//       e.response?.data["message"] ?? "Sunucu hatası",
//     );
//   }

//   return const UnknownFailure();
// }

Failure dioError(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return NetworkFailure();
  }
  if (error.response?.statusCode == 401) {
    return UnauthorizedFailure();
  }
  if (error.response != null) {
    return ServerFailure(error.response?.data["message"] ?? "Sunucu hatası");
  }
  return const UnknownFailure();
}
