part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

final class PostsFetched extends PostEvent {}

final class PostMorePostsFetched extends PostEvent {}

final class PostsRefreshed extends PostEvent {}

final class PostsTransientFailureConsumed extends PostEvent {}
