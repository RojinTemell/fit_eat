import 'package:equatable/equatable.dart';
import '../../../core/feedback/app_feedback.dart';
import '../../../core/feedback/feedback_cubit_mixin.dart';
import '../model/category_model.dart';

class CategoryState extends Equatable implements HasFeedback {
  CategoryState({
    required this.categories,
    required this.isLoading,
    this.feedback,
  });
  final List<CategoryModel> categories;
  final bool isLoading;
  @override
  final AppFeedback? feedback;

  @override
  List<Object?> get props => [categories, isLoading, feedback];
  @override
  CategoryState withFeedback(AppFeedback? feedback) =>
      copyWith(feedback: feedback);
  CategoryState copyWith({
    List<CategoryModel>? categories,
    bool? isLoading,
    Object? feedback = _absent,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      feedback: identical(feedback, _absent)
          ? this.feedback
          : feedback as AppFeedback?,
    );
  }
}

const Object _absent = Object();
