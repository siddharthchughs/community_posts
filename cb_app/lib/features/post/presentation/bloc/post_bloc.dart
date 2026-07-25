import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/posts.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'post_event.dart';
part 'post_state.dart';

const _page_size = 6;

@injectable
class PostBloc extends Bloc<PostEvent, PostListState> {
  PostBloc({required GetPostsUsecases getPostUseCase})
    : _getPostsUsecases = getPostUseCase,
      super(const PostListState()) {
    on<PostsFetched>(_getPostListLoaded);
    on<PostMorePostsFetched>(_morePostFetched);
    on<PostsRefreshed>(_newPostListUpdted);
    on<PostsTransientFailureConsumed>(_postListTransientFailureConsumed);
  }

  final GetPostsUsecases _getPostsUsecases;

  bool get _isBusy =>
      state.state == PostUIState.loading ||
      state.state == PostUIState.loadingmore ||
      state.state == PostUIState.morepostadded ||
      state.state == PostUIState.refresh;

  Future<void> _getPostListLoaded(
    PostsFetched event,
    Emitter<PostListState> emit,
  ) async {
    if (_isBusy) return;
    emit(state.copyWith(state: PostUIState.loading));
    final response = await _getPostsUsecases(
      const GetPostsParams(offset: 0, limit: _page_size),
    );
    response.fold(
      (failure) => emit(state.copyWith(state: PostUIState.failure)),
      (posts) => emit(
        state.copyWith(
          state: PostUIState.loaded,
          posts: posts,
          isLimitMax: posts.length < _page_size,
        ),
      ),
    );
  }

  Future<void> _morePostFetched(
    PostMorePostsFetched event,
    Emitter<PostListState> emit,
  ) async {
    if (_isBusy || state.isLimitMax) return;

    emit(state.copyWith(state: PostUIState.loadingmore));
    await Future.delayed(const Duration(seconds: 2));

    final resultMorePosts = await _getPostsUsecases(
      GetPostsParams(offset: state.posts.length, limit: _page_size),
    );

    resultMorePosts.fold(
      (failure) => emit(
        state.copyWith(
          state: PostUIState.loaded,
          transientFailure: () => failure,
        ),
      ),
      (newPosts) {
        emit(
          state.copyWith(
            state: PostUIState.loaded,
            posts: [...state.posts, ...newPosts],
            isLimitMax: newPosts.length < _page_size,
          ),
        );
      },
    );
  }

  Future<void> _newPostListUpdted(
    PostsRefreshed event,
    Emitter<PostListState> emit,
  ) async {
    emit(state.copyWith(state: PostUIState.refresh));

    final result = await _getPostsUsecases(
      const GetPostsParams(offset: 0, limit: _page_size),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          state: PostUIState.loaded,
          transientFailure: () => failure,
        ),
      ),
      (postsRefreshed) => emit(
        state.copyWith(
          state: PostUIState.loaded,
          posts: postsRefreshed,
          isLimitMax: postsRefreshed.length < _page_size,
        ),
      ),
    );
  }

  void _postListTransientFailureConsumed(
    PostsTransientFailureConsumed event,
    Emitter<PostListState> emit,
  ) {
    emit(state.copyWith(transientFailure: () => null));
  }
}
