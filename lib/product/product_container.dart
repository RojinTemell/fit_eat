import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_eat/features/auth_page/impl/auth_service_impl.dart';
import 'package:fit_eat/features/auth_page/repo/auth_repository_impl.dart';
import 'package:fit_eat/features/auth_page/repo/auth_service_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth_page/impl/auth_service.dart';

class ProductContainer {
  ProductContainer._();
  static final instance = ProductContainer._();
  final _getIt = GetIt.instance;

  T get<T extends Object>() => _getIt.get<T>();

  void setup() {
    // 1. External Dependencies
    _getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    _getIt.registerLazySingleton<SupabaseClient>(
      () => Supabase.instance.client,
    );

    // 2. Services
    _getIt.registerLazySingleton<IAuthService>(
      () => AuthServiceImpl(
        firebaseAuth: get<FirebaseAuth>(),
        supabaseClient: get<SupabaseClient>(),
      ),
    );

    // 3. Repositories
    _getIt.registerLazySingleton<IAuthRepository>(
      () => AuthRepositoryImpl(authService: get<IAuthService>()),
    );
  }
}
