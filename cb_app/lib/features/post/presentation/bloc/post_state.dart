part of 'post_bloc.dart';

enum PostUIState {
  initial,
  loading,
  loaded,
  failure,
  loadingmore,
  morepostadded,
  refresh,
}

class PostListState extends Equatable {
  const PostListState({
    this.state = PostUIState.initial,
    this.posts = const [],
    this.isLimitMax = false,
    this.failure,
    this.transientFailure,
    this.scrollUp,
  });

  final PostUIState state;
  final List<PostDisplayEntity> posts;
  final bool isLimitMax;
  final Failure? failure;
  final Failure? transientFailure;
  final int? scrollUp;

  PostListState copyWith({
    PostUIState? state,
    List<PostDisplayEntity>? posts,
    bool? isLimitMax,
    Failure? Function()? failure,
    Failure? Function()? transientFailure,
    int? Function()? scrollUp,
  }) {
    return PostListState(
      state: state ?? this.state,
      posts: posts ?? this.posts,
      isLimitMax: isLimitMax ?? this.isLimitMax,
      failure: failure != null ? failure() : this.failure,
      transientFailure: transientFailure != null
          ? transientFailure()
          : this.transientFailure,
      scrollUp: scrollUp != null ? scrollUp() : this.scrollUp,
    );
  }

  @override
  List<Object?> get props {
    return [state, posts, isLimitMax, failure, transientFailure, scrollUp];
  }
}

final class PostInitial extends PostListState {}
