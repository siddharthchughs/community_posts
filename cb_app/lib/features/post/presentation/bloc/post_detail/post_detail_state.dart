part of 'post_detail_bloc.dart';

enum PostDetailStatus { initial, loading, loaded, failing, submitting }

class PostDetailState extends Equatable {
  const PostDetailState({
    this.status = PostDetailStatus.initial,
    this.post,
    this.failure,
    this.transientFailure,
    this.postDeletionSuccess = false,
  });

  final PostDetailStatus status;
  final PostDisplay? post;
  final Failure? failure;
  final Failure? transientFailure;
  final bool postDeletionSuccess;

  @override
  List<Object?> get props => [status, post, failure, transientFailure];

  PostDetailState copyWith({
    PostDetailStatus? status,
    PostDisplay? Function()? post,
    Failure? Function()? failure,
    Failure? Function()? transientFailure,
    bool? postDeletionSuccess,
  }) {
    return PostDetailState(
      status: status ?? this.status,
      post: post != null ? post() : this.post,
      failure: failure != null ? failure() : this.failure,
      transientFailure: transientFailure != null
          ? transientFailure()
          : this.transientFailure,
      postDeletionSuccess: postDeletionSuccess ?? this.postDeletionSuccess,
    );
  }
}

final class PostDetailInitial extends PostDetailState {}
