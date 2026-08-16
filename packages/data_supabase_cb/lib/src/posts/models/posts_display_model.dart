import 'package:domain/posts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'posts_display_model.g.dart';

@JsonSerializable(createToJson: false)
class PostsDisplayModel extends PostDisplay {
  const PostsDisplayModel({
    required super.postId,
    required super.title,
    required super.content,
    super.imageUrl,
    required super.postCreatedAt,
    required super.postUpdatedAt,
    required super.authorID,
    required super.authorName,
    super.authorAvatarUrl,
    required super.authorRole,
    required super.likeCount,
    required super.commentCount,
    required super.currentUserLiked,
  });

  static int _safeIntFromJson(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static bool _safeBoolFromJson(Object? value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value.toString().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }

  factory PostsDisplayModel.fromJson(Map<String, dynamic> json) =>
      _$PostsDisplayModelFromJson(json);

  @JsonKey(name: 'post_id')
  @override
  String get postId;

  @JsonKey(name: 'image_url')
  @override
  String? get imageUrl;

  @JsonKey(name: 'post_created_at')
  @override
  DateTime get postCreatedAt;

  @JsonKey(name: 'post_updated_at')
  @override
  DateTime get postUpdatedAt;

  @JsonKey(name: 'author_id')
  @override
  String get authorID;

  @JsonKey(name: 'author_username')
  @override
  String get authorName;

  @JsonKey(name: 'author_avatar_url')
  @override
  String? get authorAvatarUrl;

  @JsonKey(name: 'author_role')
  @override
  String get authorRole;

  @JsonKey(name: 'like_count', fromJson: PostsDisplayModel._safeIntFromJson)
  @override
  int get likeCount;

  @JsonKey(name: 'comments_count', fromJson: PostsDisplayModel._safeIntFromJson)
  @override
  int get commentCount;

  @JsonKey(
    name: 'current_user_like',
    fromJson: PostsDisplayModel._safeBoolFromJson,
  )
  @override
  bool get currentUserLiked;
}
