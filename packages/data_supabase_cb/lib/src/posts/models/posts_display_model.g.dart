// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_display_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostsDisplayModel _$PostsDisplayModelFromJson(Map<String, dynamic> json) =>
    PostsDisplayModel(
      postId: json['post_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      postCreatedAt: DateTime.parse(json['post_created_at'] as String),
      postUpdatedAt: DateTime.parse(json['post_updated_at'] as String),
      authorID: json['author_id'] as String,
      authorName: json['author_username'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      authorRole: json['author_role'] as String,
      likeCount: PostsDisplayModel._safeIntFromJson(json['like_count']),
      commentCount: PostsDisplayModel._safeIntFromJson(json['comments_count']),
      currentUserLiked: PostsDisplayModel._safeBoolFromJson(
        json['current_user_like'],
      ),
    );
