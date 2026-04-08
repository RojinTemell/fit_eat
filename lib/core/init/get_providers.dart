import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_eat/core/cubits/bottom_sheet.dart';
import 'package:fit_eat/features/create_recipe_page/service/create_recipe_service.dart';
import 'package:fit_eat/features/create_recipe_page/service/draft_service.dart';
import 'package:fit_eat/features/create_recipe_page/viewmodel/create_recipe_viewmodel.dart';
import 'package:fit_eat/features/home_page/viewmodel/category_view_model.dart';
import 'package:fit_eat/features/ingredient/viewmodel/ingredient_viewmodel.dart';

import '../../features/auth_page/repo/auth_service_repository.dart';
import '../../features/auth_page/viewmodel/auth_viewmodel.dart';
import '../../features/splash_page/viewmodel/splash_viewmodel.dart';
import '../../product/product_container.dart';
// ProductContainer'ı import etmeyi unutma

class AppProviders {
  AppProviders._();

  static List<BlocProvider> getProviders() {
    return [
      // BlocProvider<SplashViewmodel>(
      //   lazy: false,
      //   create: (_) {
      //     return SplashViewmodel(
      //       ProductContainer.instance.get<IAuthRepository>(),
      //     );
      //   },
      // ),
      BlocProvider<AuthViewmodel>(
        lazy: false,
        create: (_) =>
            AuthViewmodel(ProductContainer.instance.get<IAuthRepository>())
              ..init(),
      ),
      BlocProvider<BottomSheetBloc>(create: (_) => BottomSheetBloc()),
      BlocProvider<IngredientViewmodel>(create: (_) => IngredientViewmodel()),
      BlocProvider<CategoryViewModel>(create: (_) => CategoryViewModel()),

      // ViewModel'leri oluştururken servisleri GetIt'ten istiyoruz
      BlocProvider<CreateRecipeViewModel>(
        create: (_) => CreateRecipeViewModel(
          ProductContainer.instance.get<CreateRecipeService>(),
          ProductContainer.instance.get<DraftRecipeService>(),
          ProductContainer.instance.get<FirebaseAuth>().currentUser?.uid ??
              "guest_user",
        ),
      ),
    ];
  }
}
