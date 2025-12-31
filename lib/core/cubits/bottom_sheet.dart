import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/text_constants.dart';

class BottomSheetBloc extends Cubit<String> {
  BottomSheetBloc() : super('');

  void showBottomSheet({
    required Widget widget,
    required BuildContext context,
    bool? isPadding,
    Color? backgroundColor,
    Color? backgroundOverrideColor, // ✅ dışarıdan özel zemin rengi
  }) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,

      backgroundColor:
          backgroundColor ?? Constant.bgBase(context), // ana sheet zemini
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (innerContext) {
        final bottomInset = MediaQuery.of(innerContext).viewInsets.bottom;
        final padding = (isPadding ?? true)
            ? EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 20)
            : EdgeInsets.zero;

        return SingleChildScrollView(
          child: SafeArea(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: bottomInset, top: 16),
              child: Container(
                color: backgroundOverrideColor ?? Colors.transparent,
                child: Padding(padding: padding, child: widget),
              ),
            ),
          ),
        );
      },
    );
  }
}

abstract class BottomSheetEvent {}

class OpenBottomSheetEvent extends BottomSheetEvent {}

class CloseBottomSheetEvent extends BottomSheetEvent {}

abstract class BottomSheetState {}

class BottomSheetOpenState extends BottomSheetState {}

class BottomSheetCloseState extends BottomSheetState {}

class BottomSheetInitial extends BottomSheetState {}
