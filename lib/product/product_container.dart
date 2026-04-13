import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth_page/impl/auth_service.dart';
import '../features/auth_page/impl/auth_service_impl.dart';
import '../features/auth_page/repo/auth_repository_impl.dart';
import '../features/auth_page/repo/auth_service_repository.dart';
import '../features/create_recipe_page/service/abstract_media_service.dart';
import '../features/create_recipe_page/service/abstract_recipe_service.dart';
import '../features/create_recipe_page/service/create_recipe_service.dart';
import '../features/create_recipe_page/service/draft_service.dart';
import '../features/create_recipe_page/service/media_service.dart';

class ProductContainer {
  ProductContainer._();
  static final instance = ProductContainer._();
  final _getIt = GetIt.instance;

  T get<T extends Object>() => _getIt.get<T>();

  void setup() {
    _getIt.registerLazySingleton<SupabaseClient>(
      () => Supabase.instance.client,
    );

    _getIt.registerLazySingleton<IRecipeService>(() => CreateRecipeService());
    _getIt.registerLazySingleton<IRecipeDraftService>(
      () => DraftRecipeService(),
    );
    _getIt.registerLazySingleton<IMediaService>(() => MediaService());

    _getIt.registerLazySingleton<IAuthService>(
      () => AuthServiceImpl(
        supabaseClient: get<SupabaseClient>(),
      ),
    );

    _getIt.registerLazySingleton<IAuthRepository>(
      () => AuthRepositoryImpl(authService: get<IAuthService>()),
    );
  }
}
