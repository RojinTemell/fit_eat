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
  late TextEditingController titleController;
  late TextEditingController detailController;
  late TextEditingController directionsController;
  late TextEditingController servingController;
  late TextEditingController minuteController;
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
    titleController = TextEditingController();
    detailController = TextEditingController();
    directionsController = TextEditingController();
    servingController = TextEditingController();
    minuteController = TextEditingController();
    ingredientSearchController = TextEditingController();
  }

  void _initializeFocusNodes() {
    titleFocusNode = FocusNode();
    detailFocusNode = FocusNode();
    directionsFocusNode = FocusNode();
    serverFocusNode = FocusNode();
    minuteFocusNode = FocusNode();
  }

  bool _validateForm() {
    // Add your validation logic
    if (titleController.text.isEmpty) {
      _showError('Title is required');
      return false;
    }

    if (directionsController.text.isEmpty) {
      _showError('Directions are required');
      return false;
    }

    if (viewModel.state.mediaList.isEmpty) {
      _showError('Please add at least one image or video');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Helper method to clear all inputs
  void clearAllInputs() {
    titleController.clear();
    detailController.clear();
    directionsController.clear();
    servingController.clear();
    minuteController.clear();
    ingredientSearchController.clear();
  }

  // Helper method to unfocus all fields
  void unfocusAll() {
    titleFocusNode.unfocus();
    detailFocusNode.unfocus();
    directionsFocusNode.unfocus();
    serverFocusNode.unfocus();
    minuteFocusNode.unfocus();
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeFocusNodes();
    super.dispose();
  }

  void _disposeControllers() {
    titleController.dispose();
    detailController.dispose();
    directionsController.dispose();
    servingController.dispose();
    minuteController.dispose();
    ingredientSearchController.dispose();
  }

  void _disposeFocusNodes() {
    titleFocusNode.dispose();
    detailFocusNode.dispose();
    directionsFocusNode.dispose();
    serverFocusNode.dispose();
    minuteFocusNode.dispose();
  }
}
