import 'package:fit_eat/features/recipe_feed/model/category_model.dart';

String selectedCategoriesString(
  List<String> selectedCategoryIds,
  List<CategoryModel> categories,
) {
  if (selectedCategoryIds.isEmpty) {
    return 'Lütfen kategori seçin';
  }

  final selectedSet = selectedCategoryIds.toSet();

  return categories
      .where((cat) => selectedSet.contains(cat.id))
      .map((cat) => cat.name)
      .join(',');
}
