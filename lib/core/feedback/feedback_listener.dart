import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/feedback/app_feedback.dart';
import '../../../core/feedback/feedback_cubit_mixin.dart';
import '../components/alert_toast.dart';

abstract class FeedbackCubit<S extends HasFeedback> extends Cubit<S>
    with FeedbackCubitMixin<S> {
  FeedbackCubit(super.initialState);
}

class FeedbackListener<S extends HasFeedback, C extends FeedbackCubit<S>>
    extends StatelessWidget {
  const FeedbackListener({
    super.key,
    required this.child,
    this.onSuccess,
    this.onError,
  });

  final Widget child;
  final void Function(BuildContext context, SuccessFeedback feedback)?
  onSuccess;
  final void Function(BuildContext context, ErrorFeedback feedback)? onError;

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, S>(
      listenWhen: (prev, curr) => curr.feedback != null,
      listener: (context, state) {
        final feedback = state.feedback;
        if (feedback == null) return;

        switch (feedback) {
          case SuccessFeedback():
            if (onSuccess != null) {
              onSuccess!(context, feedback);
            } else {
              showCustomToast(context, feedback.message, isError: false);
            }
          case ErrorFeedback():
            if (onError != null) {
              onError!(context, feedback);
            } else {
              showCustomToast(context, feedback.message, isError: true);
            }
        }
        context.read<C>().clearFeedback();
      },
      child: child,
    );
  }
}

void showCustomToast(
  BuildContext context,
  String message, {
  required bool isError,
}) {
  showAlertToast(
    context,
    type: isError ? AlertToastType.error : AlertToastType.success,
    titleWidget: Text(
      isError ? "Bir Hata Oluştu" : "İşlem Başarılı",
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    message: Text(message),
  );
}

class FeedbackHandler {
  FeedbackHandler._();

  static void handle(BuildContext context, AppFeedback feedback) {
    switch (feedback) {
      case SuccessFeedback():
        showCustomToast(context, feedback.message, isError: false);
      case ErrorFeedback():
        showCustomToast(context, feedback.message, isError: true);
    }
  }
}
