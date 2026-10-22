import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/auth_storage.dart';
import '../../../billing/presentation/providers/billing_providers.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    this.isLoading = true,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  final AuthRepository _repository;
  final AuthStorage _storage;

  AuthNotifier(this._ref, this._repository, this._storage) : super(AuthState(isLoading: true)) {
    checkAuthStatus();
  }

  void _syncAllFromCloud() {
    Future.microtask(() async {
      try {
        await _ref.read(businessRepositoryProvider).syncFromCloud();
        await _ref.read(productRepositoryProvider).syncFromCloud();
        await _ref.read(customerRepositoryProvider).syncFromCloud();
        await _ref.read(billingRepositoryProvider).syncFromCloud();
        await _ref.read(inventoryRepositoryProvider).syncFromCloud();
      } catch (e) {
        // ignore: avoid_print
        print('⚠️ [AUTH NOTIFIER] Cloud Sync Error: $e');
      }
    });
  }

  /// Check stored token and user profile on app start
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = _storage.getToken();

      if (token != null && token.isNotEmpty) {
        final userMap = _storage.getUserData();
        if (userMap != null) {
          final user = UserModel.fromJson(userMap);
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            user: user,
          );
          _syncAllFromCloud();
          return;
        }
      }
    } catch (_) {}

    state = state.copyWith(isLoading: false, isAuthenticated: false);
  }

  /// Login
  Future<bool> login(String identifier, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(identifier: identifier, password: password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
      );
      _syncAllFromCloud();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
      );
      _syncAllFromCloud();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.logout();
    state = AuthState(isLoading: false, isAuthenticated: false);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());
final authStorageProvider = Provider<AuthStorage>((ref) => AuthStorage());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(authStorageProvider);
  return AuthNotifier(ref, repository, storage);
});
