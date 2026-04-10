import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../ingredient/model/recipe_ingredient.dart';
import 'recipe_media_model.dart';

class RecipeModel extends Equatable {
  final String? id; // Firestore Document ID
  final String? userId; // Yazarın UID'si
  final String? authorName; // Hızlı erişim için yazar adı
  final String? authorAvatar;
  final String? title; //
  final String? about; //
  final List<Media>? media; //
  final List<RecipeIngredient>? ingredients; //
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

  factory RecipeModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return RecipeModel(
      id: docId ?? json['id'],
      userId: json['userId'],
      authorName: json['authorName'],
      authorAvatar: json['authorAvatar'],
      title: json['title'],
      about: json['about'],
      media: json['media'] != null
          ? (json['media'] as List).map((v) => Media.fromJson(v)).toList()
          : null,
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
                .map((e) => RecipeIngredient.fromJson(e))
                .toList()
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

      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
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

      'createdAt': createdAt,
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
      url: json['url'],
      type: json['type'] != null ? MediaType.values.byName(json['type']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'type': type?.name};
  }

  @override
  List<Object?> get props => [url, type];
}
