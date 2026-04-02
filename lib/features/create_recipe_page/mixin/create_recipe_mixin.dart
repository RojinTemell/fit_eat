// create_recipe_page_mixin.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodel/create_recipe_viewmodel.dart';

mixin CreateRecipePageMixin<T extends StatefulWidget> on State<T> {
  // ViewModel
  late CreateRecipeViewModel viewModel;
  late CreateRecipeViewModel mediaViewModel;
  final createRecipeFormKey = GlobalKey<FormState>();
  // Text Controllers
  // late TextEditingController titleController;
  // late TextEditingController detailController;
  // late TextEditingController directionsController;
  // late TextEditingController servingController;
  // late TextEditingController minuteController;
  late TextEditingController ingredientSearchController;

  // Focus Nodes (if you need them for focus management)
  late FocusNode titleFocusNode;
  late FocusNode detailFocusNode;
  late FocusNode directionsFocusNode;
  late FocusNode serverFocusNode;
  late FocusNode minuteFocusNode;

  @override
  void initState() {
    super.initState();
    _initializeViewModel();
    _initializeControllers();
    _initializeFocusNodes();
  }

  void _initializeViewModel() {
    viewModel = context.read<CreateRecipeViewModel>();
  }

  void _initializeControllers() {
    ingredientSearchController = TextEditingController();
  }

  void _initializeFocusNodes() {
    titleFocusNode = FocusNode();
    detailFocusNode = FocusNode();
    directionsFocusNode = FocusNode();
    serverFocusNode = FocusNode();
    minuteFocusNode = FocusNode();
  }

  void clearAllInputs() {
    ingredientSearchController.clear();
  }

  void unfocusAll() {
    titleFocusNode.unfocus();
    detailFocusNode.unfocus();
    directionsFocusNode.unfocus();
    serverFocusNode.unfocus();
    minuteFocusNode.unfocus();
  }

  @override
  void dispose() {
    _disposeFocusNodes();
    ingredientSearchController.dispose();
    super.dispose();
  }

  void _disposeFocusNodes() {
    titleFocusNode.dispose();
    detailFocusNode.dispose();
    directionsFocusNode.dispose();
    serverFocusNode.dispose();
    minuteFocusNode.dispose();
  }
}
