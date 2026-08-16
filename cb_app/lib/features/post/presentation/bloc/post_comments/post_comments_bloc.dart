import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/posts.dart';
import 'package:domain/src/posts/usecases/get_post_comments_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'post_comments_event.dart';
part 'post_comments_state.dart';

const _commentPageSize = 10;

@injectable
class PostCommentsBloc extends Bloc<PostCommentsEvent, PostCommentsState> {
  PostCommentsBloc({required GetPostCommentsUseCase getPostCommentsUsecases})
    : _getPostCommentsUseCase = getPostCommentsUsecases,
      super(const PostCommentsState()) {
    on<PostCommentsLoaded>(_onPostCommentsLoaded);
    on<PostCommentsLoadedMore>(_onPostCommentsLoadedMore);
    on<PostCommentsRefreshed>(_onPostCommentsRefreshed);
    on<PostCommentsTransientFailureConsumed>(
      _onPostCommentsTransientFailureConsumed,
    );
  }

  final GetPostCommentsUseCase _getPostCommentsUseCase;
  bool get _commentUIState =>
      state.uiState == PostCommentsUIState.loading ||
      state.uiState == PostCommentsUIState.fetchingMore ||
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
    PostCommentsLoadedMore event,
    Emitter<PostCommentsState> emit,
  ) async {
    if (_commentUIState || state.hasReachedMax) return;
    emit(state.copyWith(uiState: PostCommentsUIState.fetchingMore));
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
}
