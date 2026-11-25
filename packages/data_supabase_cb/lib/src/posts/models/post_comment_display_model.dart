import 'dart:convert';

import 'package:domain/posts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_comment_display_model.g.dart';

@JsonSerializable(createToJson: false)
class PostCommentDisplayModel extends CommentDisplay {
  const PostCommentDisplayModel({
    required super.id,
    required super.postId,
    required super.content,
    required super.createdAt,
    required super.authorId,
    required super.authorUserName,
    super.authorAvatarUrl,
  });

  factory PostCommentDisplayModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentDisplayModelFromJson(json);

  @JsonKey(name: 'post_id')
  @override
  String get postId;

  @JsonKey(name: 'content')
  @override
  String get content;

  @JsonKey(name: 'created_at')
  @override
  DateTime get createdAt;

  @JsonKey(name: 'author_id')
  @override
  String get authorId;

  @JsonKey(name: 'author_username')
  @override
  String get authorUserName;

  @JsonKey(name: 'author_avatar_url')
  @override
  String? get authorAvatarUrl;
}
