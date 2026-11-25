part of 'post_comments_bloc.dart';

enum PostCommentsUIState {
  initial,
  loading,
  loaded,
  failure,
  loadMore,
  refilling,
  refreshing,
  submitting,
}

class PostCommentsState extends Equatable {
  const PostCommentsState({
    this.uiState = PostCommentsUIState.initial,
    this.comments = const [],
    this.hasReachedMax = false,
    this.failure,
    this.transientFailure,
    this.submittingCommentId,
  });

  final PostCommentsUIState uiState;
  final List<CommentDisplay> comments;
  final bool hasReachedMax;
  final Failure? failure;
  final Failure? transientFailure;
  final String? submittingCommentId;

  PostCommentsState copyWith({
    PostCommentsUIState? uiState,
    List<CommentDisplay>? comments,
    bool? hasReachedMax,
    Failure? Function()? failure,
    Failure? Function()? transientFailure,
    String? Function()? submittingCommentId,
  }) {
    return PostCommentsState(
      uiState: uiState ?? this.uiState,
      comments: comments ?? this.comments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      failure: failure != null ? failure() : this.failure,
      transientFailure: transientFailure != null
          ? transientFailure()
          : this.transientFailure,
      submittingCommentId: submittingCommentId != null
          ? submittingCommentId() ?? this.submittingCommentId
          : this.submittingCommentId,
    );
  }

  @override
  List<Object?> get props => [
    uiState,
    comments,
    hasReachedMax,
    failure,
    transientFailure,
  ];
}
