import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../model/recipe_media_model.dart';
import '../model/recipe_model.dart';
import 'abstract_media_service.dart';

class MediaService implements IMediaService {
  final supabase = Supabase.instance.client;

  @override
  Future<Result<List<Media>>> uploadMedia(List<RecipeMedia> mediaList) async {
    final List<Media> uploaded = [];

    try {
      for (final media in mediaList) {
        final ext = media.file.path.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
        final bucket = media.type == MediaType.image ? 'image' : 'video';

        await supabase.storage
            .from(bucket)
            .upload(fileName, File(media.file.path));

        final url = supabase.storage.from(bucket).getPublicUrl(fileName);
        uploaded.add(Media(url: url, type: media.type));
      }
      return Success(uploaded);
    } on StorageException catch (e) {
      debugPrint('Supabase Storage error: ${e.message}');
      return Error(ServerFailure(e.message));
    } catch (e) {
      debugPrint('Media upload unexpected error: $e');
      return const Error(UnknownFailure());
    }
  }
}
