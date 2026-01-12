import 'package:fit_eat/features/home_page/state/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/entities/category/category_list.dart';
import '../../../core/entities/category/category_model.dart';

class CategoryViewModel extends Cubit<CategoryState> {
  CategoryViewModel()
    : super(CategoryState(isLoading: false, categoryList: categoryList));

  void selectCategory({required Category category}) {
    emit(state.copyWith(selectedCategory: category));
  }
}
