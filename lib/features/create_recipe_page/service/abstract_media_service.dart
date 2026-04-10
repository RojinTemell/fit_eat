import '../../../core/error/result.dart';
import '../model/recipe_media_model.dart';
import '../model/recipe_model.dart';

abstract class IMediaService {
  Future<Result<List<Media>>> uploadMedia(List<RecipeMedia> mediaList);
}
