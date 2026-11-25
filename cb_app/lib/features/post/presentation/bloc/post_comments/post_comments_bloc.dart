import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/posts.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bus/global_event.dart';
import '../../../../../core/bus/global_event_bus.dart';

part 'post_comments_event.dart';
part 'post_comments_state.dart';

const _commentPageSize = 10;

@injectable
class PostCommentsBloc extends Bloc<PostCommentsEvent, PostCommentsState> {
  PostCommentsBloc({
    required GetPostCommentsUseCase getPostCommentsUsecases,
    required CreateCommentUseCase createCommentUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
    required UpdateCommentUseCase updateCommentUseCase,
    required GetPostDetailUseCase getpostDetailUseCase,
    required GlobalEventBus globalEventBus,
  }) : _getPostCommentsUseCase = getPostCommentsUsecases,
       _createCommentUseCase = createCommentUseCase,
       _deleteCommentUseCase = deleteCommentUseCase,
       _updateCommentUseCase = updateCommentUseCase,
       _getPostDetailUseCase = getpostDetailUseCase,
       _globalEventBus = globalEventBus,
       super(const PostCommentsState()) {
    on<PostCommentsLoaded>(_onPostCommentsLoaded);
    on<PostCommentsLoadMore>(_onPostCommentsLoadedMore);
    on<PostCommentsRefreshed>(_onPostCommentsRefreshed);
    on<PostCommentsTransientFailureConsumed>(
      _onPostCommentsTransientFailureConsumed,
    );
    on<PostCommentAdded>(_onCommentAdded);
    on<PostCommentDeleted>(_onCommentDeleted);
    on<PostCommentEdited>(_onCommentEdited);
    on<_PostCommentsUpdateRequested>(_onPostCommentsListUpdated);
  }

  final GetPostCommentsUseCase _getPostCommentsUseCase;
  final CreateCommentUseCase _createCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final UpdateCommentUseCase _updateCommentUseCase;
  final GetPostDetailUseCase _getPostDetailUseCase;

  final GlobalEventBus _globalEventBus;

  bool get _commentUIState =>
      state.uiState == PostCommentsUIState.loading ||
      state.uiState == PostCommentsUIState.loadMore ||
      state.uiState == PostCommentsUIState.refreshing ||
      state.uiState == PostCommentsUIState.refilling ||
      state.uiState == PostCommentsUIState.submitting ||
      state.uiState == PostCommentsUIState.failure;

  Future<void> _onPostCommentsLoaded(
    PostCommentsLoaded event,
    Emitter<PostCommentsState> emit,
  ) async {
    if (_commentUIState) return;
    emit(state.copyWith(uiState: PostCommentsUIState.loading));
    final response = await _getPostCommentsUseCase(
      GetPostCommentParams(
        postId: event.postId,
        offset: 0,
        limit: _commentPageSize,
      ),
    );
    response.fold(
      (failure) => emit(
        state.copyWith(
          uiState: PostCommentsUIState.failure,
          failure: () => failure,
        ),
      ),
      (commentsList) => emit(
        state.copyWith(
          uiState: PostCommentsUIState.loaded,
          comments: commentsList,
          hasReachedMax: commentsList.length < _commentPageSize,
        ),
      ),
    );
  }

  Future<void> _onPostCommentsLoadedMore(
    PostCommentsLoadMore event,
    Emitter<PostCommentsState> emit,
  ) async {
    if (_commentUIState || state.hasReachedMax) return;
    emit(state.copyWith(uiState: PostCommentsUIState.loadMore));
    await Future.delayed(Duration(seconds: 2));

    final response = await _getPostCommentsUseCase(
      GetPostCommentParams(
        postId: event.postId,
        offset: state.comments.length,
        limit: _commentPageSize,
      ),
    );
    response.fold(
      (failure) => emit(
        state.copyWith(
          uiState: PostCommentsUIState.loaded,
          transientFailure: () => failure,
        ),
      ),
      (commentsList) => emit(
        state.copyWith(
          uiState: PostCommentsUIState.loaded,
          comments: [...state.comments, ...commentsList],
          hasReachedMax: commentsList.length < _commentPageSize,
        ),
      ),
    );
  }

  Future<void> _onPostCommentsRefreshed(
    PostCommentsRefreshed event,
    Emitter<PostCommentsState> emit,
  ) async {
    if (_commentUIState) return;
    emit(state.copyWith(uiState: PostCommentsUIState.refreshing));

    final result = await _getPostCommentsUseCase(
      GetPostCommentParams(
        postId: event.postId,
        offset: 0,
        limit: _commentPageSize,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(uiState: PostCommentsUIState.failure)),
      (comments) => emit(
        state.copyWith(
          uiState: PostCommentsUIState.loaded,
          comments: comments,
          hasReachedMax: comments.length < _commentPageSize,
        ),
      ),
    );
  }

  Future<void> _onPostCommentsTransientFailureConsumed(
    PostCommentsTransientFailureConsumed event,
    Emitter<PostCommentsState> emit,
  ) async {
    emit(state.copyWith(transientFailure: () => null));
  }

  Future<void> _onCommentAdded(
    PostCommentAdded event,
    Emitter<PostCommentsState> emit,
  ) async {
    if (_commentUIState) return;
    emit(
      state.copyWith(
        uiState: PostCommentsUIState.submitting,
        transientFailure: () => null,
      ),
    );

    final result = await _createCommentUseCase(
      CreateCommentParams(postId: event.postId, content: event.content),
    );
    print('result: $result');

    await result.fold(
      (failure) {
        emit(
          state.copyWith(
            uiState: PostCommentsUIState.loaded,
            transientFailure: () => failure,
          ),
        );
      },
      (commentAddedSucess) async {
        final updateComments = [commentAddedSucess, ...state.comments];
        emit(
          state.copyWith(
            uiState: PostCommentsUIState.loaded,
            comments: updateComments,
          ),
        );
      },
    );

    final updateCommentCount = await _getPostDetailUseCase(event.postId);
    updateCommentCount.fold((l) => null, (updatePostCount) {
      _globalEventBus.add(PostUpdatedDispatched(posts: updatePostCount));
    });
  }

  Future<void> _onCommentDeleted(
    PostCommentDeleted event,
    Emitter<PostCommentsState> emit,
  ) async {
    if (_commentUIState) return;

    emit(
      state.copyWith(
        submittingCommentId: () => event.commentId,
        transientFailure: () => null,
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    final result = await _deleteCommentUseCase(event.commentId);

    await result.fold(
      (failure) {
        emit(
          state.copyWith(
            submittingCommentId: () => null,
            transientFailure: () => failure,
          ),
        );
      },
      (_) async {
        final updatedComments = List<CommentDisplay>.from(state.comments)
          ..removeWhere((comment) => comment.id == event.commentId);
        emit(
          state.copyWith(
            comments: updatedComments,
            submittingCommentId: () => null,
          ),
        );

        add(_PostCommentsUpdateRequested(postId: event.postId));

        final postResult = await _getPostDetailUseCase(event.postId);
        postResult.fold((l) => null, (updatePost) {
          _globalEventBus.add(PostUpdatedDispatched(posts: updatePost));
        });
      },
    );
  }

  Future<void> _onPostCommentsListUpdated(
    _PostCommentsUpdateRequested event,
    Emitter<PostCommentsState> emit,
  ) async {
    if (_commentUIState || state.hasReachedMax) return;

    emit(state.copyWith(uiState: PostCommentsUIState.refilling));

    final updatedCommentsList = await _getPostCommentsUseCase(
      GetPostCommentParams(
        postId: event.postId,
        offset: state.comments.length,
        limit: 1,
      ),
    );

    updatedCommentsList.fold(
      (failure) {
        emit(
          state.copyWith(
            uiState: PostCommentsUIState.loaded,
            transientFailure: () => failure,
          ),
        );
      },
      (newComments) {
        if (newComments.isNotEmpty) {
          emit(
            state.copyWith(
              uiState: PostCommentsUIState.loaded,
              comments: [...state.comments, ...newComments],
            ),
          );
        } else {
          emit(
            state.copyWith(
              uiState: PostCommentsUIState.loaded,
              hasReachedMax: true,
            ),
          );
        }
      },
    );
  }

  Future<void> _onCommentEdited(
    PostCommentEdited event,
    Emitter<PostCommentsState> emit,
  ) async {
    if (_commentUIState) return;
    emit(
      state.copyWith(
        submittingCommentId: () => event.commentId,
        transientFailure: () => null,
      ),
    );

    final result = await _updateCommentUseCase(
      UpdateCommentParams(
        commentId: event.commentId,
        content: event.newContent,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            submittingCommentId: () => null,
            transientFailure: () => failure,
          ),
        );
      },
      (updateComment) {
        final updatedCoemmentList = state.comments.map((comment) {
          return comment.id == updateComment.id ? updateComment : comment;
        }).toList();
        emit(
          state.copyWith(
            comments: updatedCoemmentList,
            submittingCommentId: () => null,
          ),
        );
      },
    );
  }
}
