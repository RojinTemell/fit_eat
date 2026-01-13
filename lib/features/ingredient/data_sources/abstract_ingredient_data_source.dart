import 'package:fit_eat/features/ingredient/model/ingredient_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

abstract class IngredientLocalDataSource {
  Future<List<IngredientModel>> getIngredients();
}

class IngredientLocalDataSourceImpl implements IngredientLocalDataSource {
  final AssetBundle assetBundle;

  IngredientLocalDataSourceImpl(this.assetBundle);

  @override
  Future<List<IngredientModel>> getIngredients() async {
    final jsonString = await assetBundle.loadString(
      'assets/data/ingredients.json',
    );

    final List<dynamic> decodedJson = json.decode(jsonString);

    return decodedJson.map((e) => IngredientModel.fromJson(e)).toList();
  }
}
