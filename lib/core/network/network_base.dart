import 'package:dio/dio.dart';

class NetworkBase {
  static final NetworkBase _instance = NetworkBase._init();
  static NetworkBase get instance => _instance;
  late final Dio dio;

  NetworkBase._init() {
    dio = Dio(
      BaseOptions(
        // baseUrl: ,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(_authInterceptor());
  }
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        //    final token = await TokenManager.readToken();
        // final lang = await TokenManager.readLang();

        // if (lang != null) {
        //   options.headers['Accept-Language'] = lang;
        // }
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        //Burda token manager yapısı dil ayarı gelebilir
        handler.next(options);
      },
      // onError: _handleAuthError,
    );
  }

  // Future<void> _handleAuthError(
  //   DioException e,
  //   ErrorInterceptorHandler handler,
  // ) async {
  //   if (e.response?.statusCode != 401) {
  //     return handler.next(e);
  //   }

  //   try {
  //     final refreshToken = await TokenManager.readRefreshToken();

  //     final response = await dio.post(
  //       '/auth/token',
  //       data: {'refresh_token': refreshToken},
  //     );

  //     final newToken = response.data['access_token'];
  //     await TokenManager.writeToken(newToken);

  //     final retryResponse = await dio.request(
  //       e.requestOptions.path,
  //       options: Options(
  //         method: e.requestOptions.method,
  //         headers: {
  //           ...e.requestOptions.headers,
  //           'Authorization': 'Bearer $newToken',
  //         },
  //       ),
  //       data: e.requestOptions.data,
  //       queryParameters: e.requestOptions.queryParameters,
  //     );

  //     handler.resolve(retryResponse);
  //   } catch (_) {
  //     handler.reject(e);
  //   }
  // }
}
