import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/posts.dart';
import 'package:domain/src/posts/usecases/get_post_detail_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

@injectable
class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc({required GetPostDetailUseCase getPostDetailUseCase})
    : _getPostDetailUseCase = getPostDetailUseCase,
      super(const PostDetailState()) {
    on<PostDetailFetched>(_onPostDetailLoaded);
  }

  final GetPostDetailUseCase _getPostDetailUseCase;

  bool get _isCompleted =>
      state.status == PostDetailStatus.loading ||
      state.status == PostDetailStatus.submitting;

  Future<void> _onPostDetailLoaded(
    PostDetailFetched event,
    Emitter<PostDetailState> emit,
  ) async {
    if (_isCompleted) return;
    emit(state.copyWith(status: PostDetailStatus.loading));
    final result = await _getPostDetailUseCase(event.postId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PostDetailStatus.failing,
          failure: () => failure,
        ),
      ),
      (success) => emit(
        state.copyWith(status: PostDetailStatus.success, post: () => success),
      ),
    );
  }
}
