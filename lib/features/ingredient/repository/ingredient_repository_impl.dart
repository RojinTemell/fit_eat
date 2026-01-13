import '../data_sources/abstract_ingredient_data_source.dart';
import '../model/ingredient_model.dart';
import 'ingredient_reposiory.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  final IngredientLocalDataSource localDataSource;

  IngredientRepositoryImpl(this.localDataSource);

  @override
  Future<List<IngredientModel>> getIngredients() async {
    return await localDataSource.getIngredients();
  }
}
