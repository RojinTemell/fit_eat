import 'package:fit_eat/features/recipe_feed/viewmodel/recipe_feed_viewmodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_eat/core/cubits/bottom_sheet.dart';
import 'package:fit_eat/features/create_recipe_page/viewmodel/create_recipe_viewmodel.dart';
import 'package:fit_eat/features/home_page/viewmodel/category_view_model.dart';
import 'package:fit_eat/features/ingredient/viewmodel/ingredient_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth_page/repo/auth_service_repository.dart';
import '../../features/auth_page/viewmodel/auth_viewmodel.dart';
import '../../features/create_recipe_page/service/abstract_media_service.dart';
import '../../features/create_recipe_page/service/abstract_recipe_service.dart';
import '../../product/product_container.dart';

class AppProviders {
  AppProviders._();

  static List<BlocProvider> getProviders() {
    return [
      BlocProvider<AuthViewmodel>(
        lazy: false,
        create: (_) =>
            AuthViewmodel(ProductContainer.instance.get<IAuthRepository>()),
      ),
      BlocProvider<BottomSheetBloc>(create: (_) => BottomSheetBloc()),
      BlocProvider<IngredientViewmodel>(
        create: (_) => IngredientViewmodel(),
      ),
      BlocProvider<CategoryViewModel>(create: (_) => CategoryViewModel()),
      BlocProvider<RecipeFeedViewmodel>(
        create: (_) => RecipeFeedViewmodel(
          ProductContainer.instance.get<IRecipeService>(),
        ),
      ),
      BlocProvider<CreateRecipeViewModel>(
        create: (_) => CreateRecipeViewModel(
          ProductContainer.instance.get<IRecipeService>(),
          ProductContainer.instance.get<IRecipeDraftService>(),
          ProductContainer.instance.get<IMediaService>(),
          Supabase.instance.client.auth.currentUser?.id ?? 'guest_user',
        ),
      ),
    ];
  }
}
