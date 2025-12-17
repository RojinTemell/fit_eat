import 'package:dio/dio.dart';
import 'package:fit_eat/core/network/network_base.dart';

abstract class NetworkManager {
  final Dio dio = NetworkBase.instance.dio;

  Future<Response<T>> get<T>({required String path}) {
    return dio.get<T>(path);
  }

  Future<Response<T>> post<T>({required String path, required dynamic data}) {
    return dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>({required String path, required dynamic data}) {
    return dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>({required String path}) {
    return dio.delete<T>(path);
  }
}
