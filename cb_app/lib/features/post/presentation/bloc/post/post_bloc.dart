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

const _pageSize = 8;

@injectable
class PostBloc extends Bloc<PostEvent, PostListState> {
  PostBloc({
    required GetPostsUseCase getPostUseCase,
    required GlobalEventBus globalEventBus,
    required ToggleLikeUseCase toggleLikeUseCase,
  }) : _getPostsUsecases = getPostUseCase,
       _globalEventBus = globalEventBus,
       _toggleLikeUseCase = toggleLikeUseCase,
       super(const PostListState()) {
    on<PostsFetched>(_getPostListLoaded);
    on<PostMorePostsFetched>(_morePostFetched);
    on<PostsRefreshed>(_newPostListUpdted);
    on<PostLikeToggle>(_onPostLikeToggle);
    on<PostsTransientFailureConsumed>(_postListTransientFailureConsumed);
    on<_GlobalEventReceived>(_onEventTypeReceived);
    on<_PostListUpdatedEventRequest>(_onPostListUpdateRequest);

    _globalEventSubscription = _globalEventBus.stream.listen((event) {
      add(_GlobalEventReceived(event: event));
    });
  }

  final GetPostsUseCase _getPostsUsecases;
  final GlobalEventBus _globalEventBus;
  final ToggleLikeUseCase _toggleLikeUseCase;
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
      const GetPostsParams(offset: 0, limit: _pageSize),
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
            isLimitMax: posts.length < _pageSize,
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
      GetPostsParams(offset: state.posts.length, limit: _pageSize),
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
            isLimitMax: newPosts.length < _pageSize,
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
      const GetPostsParams(offset: 0, limit: _pageSize),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          state: PostUIState.loaded,
          transientFailure: () => failure,
        ),
      ),
      (newPosts) => emit(
        state.copyWith(
          state: PostUIState.loaded,
          posts: newPosts,
          isLimitMax: newPosts.length < _pageSize,
        ),
      ),
    );
  }

  Future<void> _onPostLikeToggle(
    PostLikeToggle event,
    Emitter<PostListState> emit,
  ) async {
    if (_isBusy) return;
    final originalList = state.posts;
    final orginalPost = event.postDisplay;
    final originalIndex = originalList.indexWhere((postUpdate) {
      return postUpdate.postId == orginalPost.postId;
    });
    if (originalIndex == -1) return;

    final updatePost = orginalPost.copyWith(
      currentUserLiked: !orginalPost.currentUserLiked,
      likesCount: orginalPost.currentUserLiked
          ? orginalPost.likesCount - 1
          : orginalPost.likesCount + 1,
    );

    final updateList = List<PostDisplay>.from(originalList);
    updateList[originalIndex] = updatePost;
    emit(state.copyWith(posts: updateList, transientFailure: () => null));

    final result = await _toggleLikeUseCase(orginalPost.postId);
    result.fold(
      (failure) {
        state.copyWith(posts: originalList, transientFailure: () => failure);
      },
      (likeResult) {
        final updatedPost = orginalPost.copyWith(
          currentUserLiked: likeResult.isLiked,
          likesCount: likeResult.likesCount,
        );
        final updatedPostList = List<PostDisplay>.from(state.posts);
        final updatedElementIndex = updatedPostList.indexWhere(
          (postUpdated) => postUpdated.postId == updatedPost.postId,
        );

        if (updatedElementIndex != -1) {
          updatedPostList[updatedElementIndex] = updatedPost;

          _globalEventBus.add(PostUpdatedDispatched(posts: updatedPost));
          emit(state.copyWith(posts: updatedPostList));
        } else {
          emit(state);
        }
      },
    );
  }

  Future<void> _onPostListUpdateRequest(
    _PostListUpdatedEventRequest event,
    Emitter<PostListState> emit,
  ) async {
    if (_isBusy || state.isLimitMax) return;
    emit(state.copyWith(state: PostUIState.loadingmore));
    final result = await _getPostsUsecases(
      GetPostsParams(offset: state.posts.length, limit: 1),
    );
    result.fold(
      (failure) {
        state.copyWith(
          state: PostUIState.loaded,
          transientFailure: () => failure,
        );
      },
      (newPosts) {
        if (newPosts.isNotEmpty) {
          emit(
            state.copyWith(
              state: PostUIState.loaded,
              posts: [...newPosts, ...state.posts],
            ),
          );
        } else {
          emit(state.copyWith(state: PostUIState.loaded, isLimitMax: true));
        }
      },
    );
  }

  void _postListTransientFailureConsumed(
    PostsTransientFailureConsumed event,
    Emitter<PostListState> emit,
  ) {
    emit(state.copyWith(transientFailure: () => null));
  }

  void _onEventTypeReceived(
    _GlobalEventReceived event,
    Emitter<PostListState> emit,
  ) {
    if (state.state != PostUIState.loadingmore && _isBusy) return;
    switch (event.event) {
      case PostCreatedDispacted(posts: final newPost):
        final currentPosts = state.posts;
        emit(state.copyWith(posts: [newPost, ...currentPosts]));

      case PostUpdatedDispatched(posts: final updatedPost):
        final currentPost = state.posts;
        final newPosts = currentPost.map((post) {
          return post.postId == updatedPost.postId ? updatedPost : post;
        }).toList();
        emit(state.copyWith(posts: newPosts));

      case PostDeletedDispatched(postId: final deletedPostId):
        final currentPost = state.posts;
        final newPost = currentPost
            .where((post) => post.postId != deletedPostId)
            .toList();
        emit(state.copyWith(posts: newPost));
        add(_PostListUpdatedEventRequest());
    }
  }

  @override
  Future<void> close() {
    _globalEventSubscription?.cancel();
    return super.close();
  }
}
