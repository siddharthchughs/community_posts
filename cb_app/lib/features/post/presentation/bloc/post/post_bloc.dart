import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/posts.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bus/global_event.dart';
import '../../../../../core/bus/global_event_bus.dart';

part 'post_event.dart';
part 'post_state.dart';

const _page_size = 8;

@injectable
class PostBloc extends Bloc<PostEvent, PostListState> {
  PostBloc({
    required GetPostsUsecases getPostUseCase,
    required GlobalEventBus globalEventBus,
  }) : _getPostsUsecases = getPostUseCase,
       _globalEventBus = globalEventBus,
       super(const PostListState()) {
    on<PostsFetched>(_getPostListLoaded);
    on<PostMorePostsFetched>(_morePostFetched);
    on<PostsRefreshed>(_newPostListUpdted);
    on<PostsTransientFailureConsumed>(_postListTransientFailureConsumed);
    on<_GlobalEventReceived>(_onGlobalEventReceived);

    _globalEventSubscription = _globalEventBus.stream.listen((event) {
      add(_GlobalEventReceived(event: event));
    });
  }

  final GetPostsUsecases _getPostsUsecases;
  final GlobalEventBus _globalEventBus;
  StreamSubscription<GlobalEvent>? _globalEventSubscription;

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
      (failure) {
        return emit(
          state.copyWith(state: PostUIState.failure, failure: () => failure),
        );
      },
      (posts) {
        print('Posts Length :: ${posts} ');
        return emit(
          state.copyWith(
            state: PostUIState.loaded,
            posts: posts,
            isLimitMax: posts.length < _page_size,
          ),
        );
      },
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

  void _onGlobalEventReceived(
    _GlobalEventReceived event,
    Emitter<PostListState> emit,
  ) {
    if (state.state != PostUIState.loadingmore && _isBusy) return;
    switch (event.event) {
      case PostCreatedDispacted(posts: final newPost):
        final currentPosts = state.posts;
        emit(state.copyWith(posts: [newPost, ...currentPosts]));
    }
  }

  @override
  Future<void> close() {
    _globalEventSubscription?.cancel();
    return super.close();
  }
}
