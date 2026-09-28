import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/posts.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bus/global_event.dart';
import '../../../../../core/bus/global_event_bus.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

@injectable
class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc({
    required GetPostDetailUseCase getPostDetailUseCase,
    required ToggleLikeUseCase toogleLikeUseCase,
    required GlobalEventBus globalEventBus,
  }) : _getPostDetailUseCase = getPostDetailUseCase,
       _toogleLikeUseCase = toogleLikeUseCase,
       _globalEventBus = globalEventBus,
       super(const PostDetailState()) {
    on<PostDetailFetched>(_onPostDetailLoaded);
    on<PostDetailLikeToggled>(_onPostDetailLikeToggle);
    on<_PostUpdatedFromBus>(_onPostUpdatedFromEventBus);

    _globalEventSubscription = _globalEventBus.stream.listen((event) {
      final postUpdatedEvent = event as PostUpdatedDispatched;
      if (state.post?.postId == postUpdatedEvent.posts.postId) {
        add(_PostUpdatedFromBus(postDisplay: postUpdatedEvent.posts));
      }
    });
  }

  final GetPostDetailUseCase _getPostDetailUseCase;
  final ToggleLikeUseCase _toogleLikeUseCase;
  final GlobalEventBus _globalEventBus;

  StreamSubscription<GlobalEvent>? _globalEventSubscription;

  bool get _isLoaded =>
      state.status == PostDetailStatus.loading ||
      state.status == PostDetailStatus.submitting;

  Future<void> _onPostDetailLoaded(
    PostDetailFetched event,
    Emitter<PostDetailState> emit,
  ) async {
    if (_isLoaded) return;
    emit(state.copyWith(status: PostDetailStatus.loading));
    if (event.initialPost != null) {
      emit(
        state.copyWith(
          status: PostDetailStatus.loaded,
          post: () => event.initialPost,
        ),
      );
    } else {
      emit(state.copyWith(status: PostDetailStatus.loading));
    }

    final result = await _getPostDetailUseCase(event.postId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PostDetailStatus.failing,
          failure: () => failure,
        ),
      ),
      (post) => emit(
        state.copyWith(
          status: PostDetailStatus.loaded,
          post: () => event.initialPost == null
              ? post
              : post.copyWith(
                  likesCount: event.initialPost!.likesCount,
                  currentUserLiked: event.initialPost!.currentUserLiked,
                ),
        ),
      ),
    );
    print('Post Detail Bloc :: ${state.post?.likesCount}');
  }

  Future<void> _onPostDetailLikeToggle(
    PostDetailLikeToggled event,
    Emitter<PostDetailState> emit,
  ) async {
    if (_isLoaded || state.post == null) return;

    final originalPost = state.post!;

    final goodPost = originalPost.copyWith(
      currentUserLiked: !originalPost.currentUserLiked,
      likesCount: originalPost.currentUserLiked
          ? originalPost.likesCount - 1
          : originalPost.likesCount + 1,
    );

    emit(state.copyWith(post: () => goodPost, transientFailure: () => null));

    final resultOnPostLiked = await _toogleLikeUseCase(originalPost.postId);

    resultOnPostLiked.fold(
      (failure) {
        emit(
          state.copyWith(
            post: () => originalPost,
            transientFailure: () => null,
          ),
        );
      },
      (likedPost) {
        final authoriativePost = originalPost.copyWith(
          currentUserLiked: likedPost.isLiked,
          likesCount: likedPost.likesCount,
        );
        emit(state.copyWith(post: () => authoriativePost));
        _globalEventBus.add(PostUpdatedDispatched(posts: authoriativePost));
      },
    );
  }

  void _onPostUpdatedFromEventBus(
    _PostUpdatedFromBus event,
    Emitter<PostDetailState> emit,
  ) {
    if (state.status == PostDetailStatus.loaded) {
      emit(state.copyWith(post: () => event.postDisplay));
    }
  }

  @override
  Future<void> close() {
    _globalEventSubscription?.cancel();
    return super.close();
  }
}
