import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class PostDisplay extends Equatable {
  const PostDisplay({
    required this.postId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.postCreatedAt,
    required this.postUpdatedAt,
    required this.authorID,
    required this.authorName,
    this.authorAvatarUrl,
    required this.authorRole,
    required this.likesCount,
    required this.commentCount,
    required this.currentUserLiked,
  });

  final String postId;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime postCreatedAt;
  final DateTime postUpdatedAt;
  final String authorID;
  final String authorName;
  final String? authorAvatarUrl;
  final String authorRole;
  final int likesCount;
  final int commentCount;
  final bool currentUserLiked;

  @override
  List<Object?> get props {
    return [
      postId,
      title,
      content,
      imageUrl,
      postCreatedAt,
      postUpdatedAt,
      authorID,
      authorName,
      authorAvatarUrl,
      authorRole,
      likesCount,
      commentCount,
      currentUserLiked,
    ];
  }

  PostDisplay copyWith({
    String? postId,
    String? title,
    String? content,
    ValueGetter<String?>? imageUrl,
    DateTime? postCreatedAt,
    DateTime? postUpdatedAt,
    String? authorID,
    String? authorName,
    ValueGetter<String?>? authorAvatarUrl,
    String? authorRole,
    int? likesCount,
    int? commentCount,
    bool? currentUserLiked,
  }) {
    return PostDisplay(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl != null ? imageUrl() : this.imageUrl,
      postCreatedAt: postCreatedAt ?? this.postCreatedAt,
      postUpdatedAt: postUpdatedAt ?? this.postUpdatedAt,
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl != null
          ? authorAvatarUrl()
          : this.authorAvatarUrl,
      authorRole: authorRole ?? this.authorRole,
      likesCount: likesCount ?? this.likesCount,
      commentCount: commentCount ?? this.commentCount,
      currentUserLiked: currentUserLiked ?? this.currentUserLiked,
    );
  }
}
