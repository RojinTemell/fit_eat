import 'package:image_picker/image_picker.dart';

enum MediaType { image, video }

class RecipeMedia {
  final XFile file;
  final MediaType type;

  const RecipeMedia({required this.file, required this.type});
}
