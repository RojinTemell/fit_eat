import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String slug;
  final String name;
  final String? emoji;
  final int sortOrder;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.slug,
    required this.name,
    this.emoji,
    required this.sortOrder,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String?, // nullable
      sortOrder: json['sort_order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'emoji': emoji,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, slug, name, emoji, sortOrder, createdAt];
}
