import 'package:equatable/equatable.dart';
import '../../../core/entities/category/category_model.dart';

class CategoryState extends Equatable {
  const CategoryState({
    required this.isLoading,
    required this.categoryList,
    this.selectedCategory,
  });
  final bool isLoading;
  final List<Category> categoryList;
  final Category? selectedCategory;

  @override
  List<Object?> get props => [isLoading, categoryList, selectedCategory];
  CategoryState copyWith({
    bool? isLoading,
    List<Category>? categoryList,
    Category? selectedCategory,
  }) => CategoryState(
    isLoading: isLoading ?? this.isLoading,
    categoryList: categoryList ?? this.categoryList,
    selectedCategory: selectedCategory ?? this.selectedCategory,
  );
}
