import 'dart:convert';

import 'package:domain/posts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_comment_model.g.dart';

@JsonSerializable(createToJson: false)
class PostCommentModel extends CommentDisplay {
  const PostCommentModel({
    required super.postId,
    required super.content,
    required super.createdAt,
    required super.authorId,
    required super.authorUserName,
    super.authorAvatarUrl,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentModelFromJson(json);

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
