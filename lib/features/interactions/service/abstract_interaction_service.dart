import 'package:fit_eat/core/error/result.dart';

abstract interface class IInteractionService {
  /// Toggles like for the current user.
  /// Returns `true` if now liked, `false` if unliked.
  Future<Result<bool>> toggleLike({
    required String contentId,
    required String contentType,
  });

  /// Returns `true` if the current user has liked this content.
  Future<Result<bool>> isLiked({
    required String contentId,
    required String contentType,
  });

  /// Logs a view — idempotent (one count per user per content).
  Future<Result<void>> logView({
    required String contentId,
    required String contentType,
  });

  /// Logs a share event.
  Future<Result<void>> logShare({
    required String contentId,
    required String contentType,
    String? platform,
  });
}
