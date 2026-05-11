import 'package:fit_eat/core/error/result.dart';
import 'package:fit_eat/features/recipe_feed/model/category_model.dart';

abstract class IRecipeFeedService {
  Future<Result<List<CategoryModel>>> getCategories();
}