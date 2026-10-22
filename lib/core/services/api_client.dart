import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'auth_storage.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio dio;
  final AuthStorage _authStorage = AuthStorage();

  factory ApiClient({String? baseUrl}) {
    _instance ??= ApiClient._internal(baseUrl);
    return _instance!;
  }

  ApiClient._internal(String? baseUrl) {
    final activeUrl = baseUrl ?? AppConfig.activeBaseUrl;

    dio = Dio(
      BaseOptions(
        baseUrl: activeUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Attach Interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final token = _authStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            await _authStorage.clearAuth();
          }
          return handler.next(error);
        },
      ),
    );
  }
}
