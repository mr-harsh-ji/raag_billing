import 'package:dio/dio.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/auth_storage.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  AuthRepository({
    ApiClient? apiClient,
    AuthStorage? authStorage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _authStorage = authStorage ?? AuthStorage();

  /// Register User
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _apiClient.dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      });

      if (response.data['success'] == true) {
        final data = response.data['data'];
        final token = data['token'].toString();
        final user = UserModel.fromJson(data['user']);

        await _authStorage.saveToken(token);
        await _authStorage.saveUserData(user.toJson());

        return user;
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed.');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message ?? 'Server error during registration.';
      throw Exception(errorMsg);
    }
  }

  /// Login User
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    try {
      // ignore: avoid_print
      print('🌐 [AUTH REPO] Posting to: ${_apiClient.dio.options.baseUrl}/auth/login');

      final response = await _apiClient.dio.post('/auth/login', data: {
        'email_or_phone': identifier,
        'password': password,
      });

      // ignore: avoid_print
      print('✅ [AUTH REPO] Response (${response.statusCode}): ${response.data}');

      if (response.data['success'] == true) {
        final data = response.data['data'];
        final token = data['token'].toString();
        final user = UserModel.fromJson(data['user']);

        await _authStorage.saveToken(token);
        await _authStorage.saveUserData(user.toJson());

        if (data['businessProfile'] != null) {
          await _authStorage.saveBusinessProfile(data['businessProfile']);
        }

        return user;
      } else {
        throw Exception(response.data['message'] ?? 'Login failed.');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message ?? 'Network error connecting to backend.';
      // ignore: avoid_print
      print('❌ [AUTH REPO] DioException: ${e.type} | Message: $errorMsg | URL: ${e.requestOptions.uri}');
      throw Exception(errorMsg);
    } catch (e) {
      // ignore: avoid_print
      print('💥 [AUTH REPO] Unknown Exception: $e');
      rethrow;
    }
  }

  /// Fetch Authenticated Profile
  Future<UserModel?> getMe() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');

      if (response.data['success'] == true) {
        final user = UserModel.fromJson(response.data['data']['user']);
        await _authStorage.saveUserData(user.toJson());
        return user;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Logout User
  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } catch (_) {}
    await _authStorage.clearAuth();
  }
}
