import 'package:equatable/equatable.dart';

class CommentDisplay extends Equatable {
  const CommentDisplay({
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.authorId,
    required this.authorUserName,
    this.authorAvatarUrl,
  });
  final String postId;
  final String content;
  final DateTime createdAt;
  final String authorId;
  final String authorUserName;
  final String? authorAvatarUrl;

  @override
  List<Object?> get props {
    return [
      postId,
      content,
      createdAt,
      authorId,
      authorUserName,
      authorAvatarUrl,
    ];
  }
}
