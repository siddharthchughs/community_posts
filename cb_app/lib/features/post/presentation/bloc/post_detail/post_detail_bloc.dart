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
    required DeletePostUseCase deletePostUseCase,
    required DeletePostimageFolderUseCase deletePostImageFolderUseCase,
  }) : _getPostDetailUseCase = getPostDetailUseCase,
       _toogleLikeUseCase = toogleLikeUseCase,
       _globalEventBus = globalEventBus,
       _deletePostUseCase = deletePostUseCase,
       _deletePostImageFolderUseCase = deletePostImageFolderUseCase,
       super(const PostDetailState()) {
    on<PostDetailFetched>(_onPostDetailLoaded);
    on<PostDetailLikeToggled>(_onPostDetailLikeToggle);
    on<PostDeletedEvent>(_onPostDeleted);
    on<PostDetailTransientFailureConsumed>(
      _onPostDetailTransientFailureConsumed,
    );
    on<_PostUpdatedFromBus>(_onPostUpdatedFromEventBus);

    _globalEventSubscription = _globalEventBus.stream.listen((event) {
      if (event is PostUpdatedDispatched) {
        if (state.post?.postId == event.posts.postId) {
          add(_PostUpdatedFromBus(postDisplay: event.posts));
        }
      }
    });
  }

  final GetPostDetailUseCase _getPostDetailUseCase;
  final ToggleLikeUseCase _toogleLikeUseCase;
  final GlobalEventBus _globalEventBus;
  final DeletePostUseCase _deletePostUseCase;
  final DeletePostimageFolderUseCase _deletePostImageFolderUseCase;

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

    emit(
      state.copyWith(
        //        status: PostDetailStatus.submitting,
        post: () => goodPost,
        transientFailure: () => null,
      ),
    );

    final resultOnPostLiked = await _toogleLikeUseCase(originalPost.postId);

    resultOnPostLiked.fold(
      (failure) {
        emit(
          state.copyWith(
            //            status: PostDetailStatus.loaded,
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
        emit(
          state.copyWith(
            status: PostDetailStatus.loaded,
            post: () => authoriativePost,
          ),
        );
        _globalEventBus.add(PostUpdatedDispatched(posts: authoriativePost));
      },
    );
  }

  void _onPostDetailTransientFailureConsumed(
    PostDetailTransientFailureConsumed evemt,
    Emitter<PostDetailState> emit,
  ) {
    emit(state.copyWith(transientFailure: () => null));
  }

  void _onPostUpdatedFromEventBus(
    _PostUpdatedFromBus event,
    Emitter<PostDetailState> emit,
  ) {
    if (state.status == PostDetailStatus.loaded) {
      emit(state.copyWith(post: () => event.postDisplay));
    }
  }

  Future<void> _onPostDeleted(
    PostDetailEvent event,
    Emitter<PostDetailState> emit,
  ) async {
    if (_isLoaded || state.post == null) return;
    final postDelete = state.post!;
    emit(
      state.copyWith(
        status: PostDetailStatus.submitting,
        transientFailure: () => null,
      ),
    );
    await Future.delayed(const Duration(seconds: 5));
    final result = await _deletePostUseCase(postDelete.postId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: PostDetailStatus.loaded,
            transientFailure: () => failure,
          ),
        );
      },
      (_) => {
        if (postDelete.imageUrl != null)
          {_deletePostImageFolderUseCase(postDelete.postId)},
        _globalEventBus.add(PostDeletedDispatched(postId: postDelete.postId)),
        emit(
          state.copyWith(
            status: PostDetailStatus.loaded,
            postDeletionSuccess: true,
          ),
        ),
      },
    );
  }

  @override
  Future<void> close() {
    _globalEventSubscription?.cancel();
    return super.close();
  }
}
