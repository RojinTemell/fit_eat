import '../../../core/components/chip.dart';

enum RecipeDifficulty { easy, medium, hard }

extension RecipeDifficultyExtension on RecipeDifficulty {
  String get title {
    switch (this) {
      case RecipeDifficulty.easy:
        return "easy";
      case RecipeDifficulty.medium:
        return "medium";
      case RecipeDifficulty.hard:
        return "hard";
    }
  }

  ColorType get selectedType {
    switch (this) {
      case RecipeDifficulty.easy:
        return ColorType.filledWarning;
      case RecipeDifficulty.medium:
        return ColorType.filledInfo;
      case RecipeDifficulty.hard:
        return ColorType.filledError;
    }
  }

  ColorType get type {
    switch (this) {
      case RecipeDifficulty.easy:
        return ColorType.outlinedWarning;
      case RecipeDifficulty.medium:
        return ColorType.outlinedInfo;
      case RecipeDifficulty.hard:
        return ColorType.outlinedError;
    }
  }
}
