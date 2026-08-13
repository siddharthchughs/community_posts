// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentModel _$PostCommentModelFromJson(Map<String, dynamic> json) =>
    PostCommentModel(
      postId: json['post_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorId: json['author_id'] as String,
      authorUserName: json['author_username'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
    );
