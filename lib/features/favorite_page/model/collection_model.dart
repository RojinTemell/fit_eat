import 'package:equatable/equatable.dart';

class CollectionModel extends Equatable {
  const CollectionModel({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.coverUrl,
    this.isPublic = false,
    this.itemCount = 0,
    this.createdAt,
  });

  final String? id;
  final String? userId;
  final String? name;
  final String? description;
  final String? coverUrl;
  final bool isPublic;
  final int itemCount;
  final DateTime? createdAt;

  factory CollectionModel.fromSupabase(Map<String, dynamic> row) {
    return CollectionModel(
      id: row['id'] as String?,
      userId: row['user_id'] as String?,
      name: row['name'] as String?,
      description: row['description'] as String?,
      coverUrl: row['cover_url'] as String?,
      isPublic: row['is_public'] as bool? ?? false,
      itemCount: row['item_count'] as int? ?? 0,
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'].toString())
          : null,
    );
  }

  CollectionModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? coverUrl,
    bool? isPublic,
    int? itemCount,
    DateTime? createdAt,
  }) {
    return CollectionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      isPublic: isPublic ?? this.isPublic,
      itemCount: itemCount ?? this.itemCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        coverUrl,
        isPublic,
        itemCount,
        createdAt,
      ];
}
