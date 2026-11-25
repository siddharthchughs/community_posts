part of 'post_comments_bloc.dart';

sealed class PostCommentsEvent extends Equatable {
  const PostCommentsEvent();

  @override
  List<Object?> get props => [];
}

final class PostCommentsLoaded extends PostCommentsEvent {
  const PostCommentsLoaded({required this.postId});
  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PostCommentsLoadMore extends PostCommentsEvent {
  const PostCommentsLoadMore({required this.postId});
  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PostCommentsRefreshed extends PostCommentsEvent {
  const PostCommentsRefreshed({required this.postId});
  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PostCommentsTransientFailureConsumed extends PostCommentsEvent {
  const PostCommentsTransientFailureConsumed();
}

final class PostCommentAdded extends PostCommentsEvent {
  const PostCommentAdded({required this.postId, required this.content});

  final String postId;
  final String content;

  @override
  List<Object?> get props => [postId, content];
}

final class PostCommentDeleted extends PostCommentsEvent {
  const PostCommentDeleted({required this.postId, required this.commentId});

  final String postId;
  final String commentId;
}

final class PostCommentEdited extends PostCommentsEvent {
  const PostCommentEdited({required this.commentId, required this.newContent});

  final String commentId;
  final String newContent;
}

final class _PostCommentsUpdateRequested extends PostCommentsEvent {
  const _PostCommentsUpdateRequested({required this.postId});
  final String postId;

  @override
  List<Object?> get props => [postId];
}
