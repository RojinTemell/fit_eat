import 'package:equatable/equatable.dart';

class RecipeModel extends Equatable {
  final String? title; //
  final String? about; //
  final List<Media>? media;//
  final List<String>? ingredients; //
  final List<String>? steps; //
  final String? difficulty; //
  final int? serving; //
  final int? duration; //
  final List<String>? categories; //
  final int? calorie;
  final int? viewCount; //başlangıça 0 olucak oluşturulunca
  final int? favoriteCount; //başlangıça 0 olucak oluşturulunca
  final double? ratingAverage; //başlangıça 0 olucak oluşturulunca
  final int? ratingCount; //başlangıça 0 olucak oluşturulunca
  final String? userId;
  final DateTime? createdAt;

  const RecipeModel({
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
    this.userId,
    this.createdAt,
  });

  /// 🔁 copyWith
  RecipeModel copyWith({
    String? title,
    String? about,
    List<Media>? media,
    List<String>? ingredients,
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
    );
  }

  /// 🔥 Firestore / JSON
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      title: json['title'],
      about: json['about'],
      media: json['media'] != null
          ? (json['media'] as List).map((v) => Media.fromJson(v)).toList()
          : null,
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
      steps: json['steps'] != null ? List<String>.from(json['steps']) : null,
      difficulty: json['difficulty'],
      serving: json['serving'],
      duration: json['duration'],
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : null,
      calorie: json['calorie'],
      viewCount: json['viewCount'],
      favoriteCount: json['favoriteCount'],
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble(),
      ratingCount: json['ratingCount'],
      userId: json['userId'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'about': about,
      'media': media?.map((v) => v.toJson()).toList(),
      'ingredients': ingredients,
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
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
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
    return Media(url: json['url'], type: json['type']);
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'type': type};
  }

  @override
  List<Object?> get props => [url, type];
}

enum MediaType { image, video }
