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

final class PostCommentsLoadedMore extends PostCommentsEvent {
  const PostCommentsLoadedMore({required this.postId});
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
