import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum MediaType { image, video }

class RecipeMedia extends Equatable {
  final XFile file;
  final MediaType type;

  const RecipeMedia({required this.file, required this.type});

  @override
  List<Object> get props => [file.path, type];
}
