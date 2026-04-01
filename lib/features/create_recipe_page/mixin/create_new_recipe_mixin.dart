import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewmodel/create_recipe_viewmodel.dart';

mixin CreateNewRecipeMixin<T extends StatefulWidget> on State<T> {
  late CreateRecipeViewModel viewModel;
  late TextEditingController titleController;
  late TextEditingController unitController;
  late TextEditingController calController;
  late TextEditingController carbsController;
  late TextEditingController fatController;
  late TextEditingController protienController;
  @override
  void initState() {
    super.initState();
    viewModel = context.read<CreateRecipeViewModel>();
    _initializeControllers();
  }

  void _initializeControllers() {
    titleController = TextEditingController();
    unitController = TextEditingController();
    calController = TextEditingController();
    carbsController = TextEditingController();
    fatController = TextEditingController();
    protienController = TextEditingController();
  }

  void clearAllInputs() {
    titleController.clear();
    unitController.clear();
    calController.clear();
    carbsController.clear();
    fatController.clear();
    protienController.clear();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    titleController.dispose();
    unitController.dispose();
    calController.dispose();
    carbsController.dispose();
    fatController.dispose();
    protienController.dispose();
  }
}
