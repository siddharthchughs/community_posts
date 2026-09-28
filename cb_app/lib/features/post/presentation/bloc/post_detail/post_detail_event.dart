part of 'post_detail_bloc.dart';

sealed class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object?> get props => [];
}

final class PostDetailFetched extends PostDetailEvent {
  const PostDetailFetched({required this.postId, this.initialPost});
  final String postId;
  final PostDisplay? initialPost;

  @override
  List<Object?> get props => [postId, initialPost];
}

final class PostDetailLikeToggled extends PostDetailEvent {
  const PostDetailLikeToggled();
}

final class _PostUpdatedFromBus extends PostDetailEvent {
  const _PostUpdatedFromBus({required this.postDisplay});
  final PostDisplay postDisplay;
}
