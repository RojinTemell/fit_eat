import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_eat/core/cubits/bottom_sheet.dart';
import 'package:fit_eat/features/create_recipe_page/service/draft_service.dart';
import 'package:fit_eat/features/ingredient/viewmodel/ingredient_viewmodel.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/create_recipe_page/service/create_recipe_service.dart';
import '../../features/create_recipe_page/viewmodel/create_recipe_viewmodel.dart';
import '../../features/home_page/viewmodel/category_view_model.dart';
// import '../../features/ingredient/data_sources/abstract_ingredient_data_source.dart';
// import '../../features/ingredient/repository/ingredient_reposiory.dart';
// import '../../features/ingredient/repository/ingredient_repository_impl.dart';

class AppProviders {
  AppProviders._();

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static final _recipeService = CreateRecipeService(firestore: _firestore);
  static final _recipeDraftService = DraftRecipeService(firestore: _firestore);

  static String get currentUserId => _auth.currentUser?.uid ?? "guest_user";

  static List<BlocProvider> getProviders() {
    return [
      BlocProvider<BottomSheetBloc>(create: (_) => BottomSheetBloc()),
      BlocProvider<IngredientViewmodel>(create: (_) => IngredientViewmodel()),
      BlocProvider<CreateRecipeViewModel>(
        create: (_) => CreateRecipeViewModel(
          _recipeService,
          _recipeDraftService,
          currentUserId,
        ),
      ),
      BlocProvider<CategoryViewModel>(create: (_) => CategoryViewModel()),
    ];
  }
}
