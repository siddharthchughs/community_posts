import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../posts.dart';

class CreateCommentParams extends Equatable {
  const CreateCommentParams({required this.postId, required this.content});
  final String postId;
  final String content;

  @override
  List<Object?> get props => [postId, content];
}

class CreateCommentUseCase
    implements Usecase<CommentDisplay, CreateCommentParams> {
  CreateCommentUseCase({required PostsRepository postReository})
    : _postsRepository = postReository;

  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, CommentDisplay>> call(
    CreateCommentParams params,
  ) async {
    return await _postsRepository.createComment(
      postId: params.postId,
      newContent: params.content,
    );
  }
}
