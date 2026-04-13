import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  const CommentModel({
    this.id,
    this.userId,
    this.contentId,
    this.contentType,
    this.parentId,
    this.body,
    this.authorName,
    this.authorAvatar,
    this.createdAt,
  });

  final String? id;
  final String? userId;
  final String? contentId;
  final String? contentType;
  final String? parentId;
  final String? body;
  final String? authorName;
  final String? authorAvatar;
  final DateTime? createdAt;

  factory CommentModel.fromSupabase(Map<String, dynamic> row) {
    final user = row['users'] as Map<String, dynamic>?;
    return CommentModel(
      id: row['id'] as String?,
      userId: row['user_id'] as String?,
      contentId: row['content_id'] as String?,
      contentType: row['content_type'] as String?,
      parentId: row['parent_id'] as String?,
      body: row['body'] as String?,
      authorName: user?['display_name'] as String?,
      authorAvatar: user?['avatar_url'] as String?,
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        contentId,
        contentType,
        parentId,
        body,
        authorName,
        authorAvatar,
        createdAt,
      ];
}
