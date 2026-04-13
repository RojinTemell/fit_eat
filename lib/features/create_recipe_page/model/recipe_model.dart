import 'package:equatable/equatable.dart';
import '../../ingredient/model/recipe_ingredient.dart';
import 'recipe_media_model.dart';

class RecipeModel extends Equatable {
  final String? id;
  final String? userId;
  final String? authorName;
  final String? authorAvatar;
  final String? title;
  final String? about;
  final List<Media>? media;
  final List<RecipeIngredient>? ingredients;
  final List<String>? steps;
  final String? difficulty;
  final int? serving;
  final int? duration;
  final List<String>? categories;
  final int? calorie;
  final int? viewCount;
  final int? favoriteCount;
  final double? ratingAverage;
  final int? ratingCount;
  final DateTime? createdAt;

  const RecipeModel({
    this.id,
    this.userId,
    this.authorName,
    this.authorAvatar,
    this.title,
    this.about,
    this.media,
    this.ingredients,
    this.steps,
    this.difficulty,
    this.serving,
    this.duration,
    this.categories,
    this.calorie,
    this.viewCount,
    this.favoriteCount,
    this.ratingAverage,
    this.ratingCount,
    this.createdAt,
  });

  RecipeModel copyWith({
    String? id,
    String? authorName,
    String? authorAvatar,
    String? title,
    String? about,
    List<Media>? media,
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
    String? difficulty,
    int? serving,
    int? duration,
    List<String>? categories,
    int? calorie,
    int? viewCount,
    int? favoriteCount,
    double? ratingAverage,
    int? ratingCount,
    String? userId,
    DateTime? createdAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      about: about ?? this.about,
      media: media ?? this.media,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      difficulty: difficulty ?? this.difficulty,
      serving: serving ?? this.serving,
      duration: duration ?? this.duration,
      categories: categories ?? this.categories,
      calorie: calorie ?? this.calorie,
      viewCount: viewCount ?? this.viewCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      ratingCount: ratingCount ?? this.ratingCount,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
    );
  }

  // ─── LOCAL STORAGE (drafts via SharedPreferences) ────────────────────────

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      authorName: json['authorName'] as String?,
      authorAvatar: json['authorAvatar'] as String?,
      title: json['title'] as String?,
      about: json['about'] as String?,
      media: json['media'] != null
          ? (json['media'] as List)
                .map((v) => Media.fromJson(v as Map<String, dynamic>))
                .toList()
          : null,
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
                .map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      steps:
          json['steps'] != null ? List<String>.from(json['steps'] as List) : null,
      difficulty: json['difficulty'] as String?,
      serving: json['serving'] as int?,
      duration: json['duration'] as int?,
      categories: json['categories'] != null
          ? List<String>.from(json['categories'] as List)
          : null,
      calorie: json['calorie'] as int?,
      viewCount: json['viewCount'] as int?,
      favoriteCount: json['favoriteCount'] as int?,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble(),
      ratingCount: json['ratingCount'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'title': title,
      'about': about,
      'media': media?.map((v) => v.toJson()).toList(),
      'ingredients': ingredients
          ?.map(
            (e) => RecipeIngredient(
              name: e.name,
              unit: e.unit,
              amount: e.amount,
              caloriesPer100g: e.caloriesPer100g,
              gramsPerPiece: e.gramsPerPiece,
            ).toJson(),
          )
          .toList(),
      'steps': steps,
      'difficulty': difficulty,
      'serving': serving,
      'duration': duration,
      'categories': categories,
      'calorie': calorie,
      'viewCount': viewCount,
      'favoriteCount': favoriteCount,
      'ratingAverage': ratingAverage,
      'ratingCount': ratingCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // ─── SUPABASE (recipes table) ─────────────────────────────────────────────

  /// Reads a row from the `recipes` table, with optional JOIN on `users`.
  factory RecipeModel.fromSupabase(Map<String, dynamic> row) {
    final user = row['users'] as Map<String, dynamic>?;
    return RecipeModel(
      id: row['id'] as String?,
      userId: row['user_id'] as String?,
      authorName: user?['display_name'] as String?,
      authorAvatar: user?['avatar_url'] as String?,
      title: row['title'] as String?,
      about: row['description'] as String?,
      media: row['media'] != null
          ? (row['media'] as List)
                .map((v) => Media.fromJson(v as Map<String, dynamic>))
                .toList()
          : null,
      ingredients: row['ingredients'] != null
          ? (row['ingredients'] as List)
                .map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      steps: row['steps'] != null
          ? List<String>.from(row['steps'] as List)
          : null,
      difficulty: row['difficulty'] as String?,
      serving: row['serving_count'] as int?,
      duration: row['duration_min'] as int?,
      categories: row['categories'] != null
          ? List<String>.from(row['categories'] as List)
          : null,
      calorie: row['calorie_per_serving'] as int?,
      viewCount: row['view_count'] as int?,
      favoriteCount: row['like_count'] as int?,
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'].toString())
          : null,
    );
  }

  /// Serializes for INSERT / UPDATE into the `recipes` Supabase table.
  Map<String, dynamic> toSupabase() {
    final coverUrl = media
        ?.firstWhere(
          (m) => m.type == MediaType.image,
          orElse: () => const Media(),
        )
        .url;
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'title': title,
      'description': about,
      'media': media?.map((v) => v.toJson()).toList() ?? [],
      'cover_image_url': coverUrl,
      'ingredients': ingredients
              ?.map(
                (e) => RecipeIngredient(
                  name: e.name,
                  unit: e.unit,
                  amount: e.amount,
                  caloriesPer100g: e.caloriesPer100g,
                  gramsPerPiece: e.gramsPerPiece,
                ).toJson(),
              )
              .toList() ??
          [],
      'steps': steps ?? [],
      'difficulty': difficulty,
      'serving_count': serving,
      'duration_min': duration,
      'categories': categories ?? [],
      'calorie_per_serving': calorie,
      'view_count': viewCount ?? 0,
      'like_count': favoriteCount ?? 0,
      'status': 'published',
    };
  }

  @override
  List<Object?> get props => [
        id,
        authorName,
        authorAvatar,
        title,
        about,
        media,
        ingredients,
        steps,
        difficulty,
        serving,
        duration,
        categories,
        calorie,
        viewCount,
        favoriteCount,
        ratingAverage,
        ratingCount,
        userId,
        createdAt,
      ];
}

class Media extends Equatable {
  const Media({this.url, this.type});

  final String? url;
  final MediaType? type;

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      url: json['url'] as String?,
      type: json['type'] != null
          ? MediaType.values.byName(json['type'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'type': type?.name};
  }

  @override
  List<Object?> get props => [url, type];
}
