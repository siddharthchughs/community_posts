// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_display_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentDisplayModel _$PostCommentDisplayModelFromJson(
  Map<String, dynamic> json,
) => PostCommentDisplayModel(
  id: json['id'] as String,
  postId: json['post_id'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  authorId: json['author_id'] as String,
  authorUserName: json['author_username'] as String,
  authorAvatarUrl: json['author_avatar_url'] as String?,
);
