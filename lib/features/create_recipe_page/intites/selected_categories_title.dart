import 'package:fit_eat/core/entities/category/category_model.dart';

String selectedCategoriesString(
  List<String> selectedCategoryIds,
  List<Category> categories,
) {
  if (selectedCategoryIds.isEmpty) {
    return 'Lütfen kategori seçin';
  }

  final selectedSet = selectedCategoryIds.toSet();

  return categories
      .where((cat) => selectedSet.contains(cat.id))
      .map((cat) => cat.title)
      .join(',');
}
