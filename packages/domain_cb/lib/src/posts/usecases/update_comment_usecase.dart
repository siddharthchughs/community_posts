import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../posts.dart';

class UpdateCommentParams extends Equatable {
  const UpdateCommentParams({required this.commentId, required this.content});
  final String commentId;
  final String content;

  @override
  List<Object?> get props => [commentId, content];
}

class UpdateCommentUseCase
    implements Usecase<CommentDisplay, UpdateCommentParams> {
  UpdateCommentUseCase({required PostsRepository postReository})
    : _postsRepository = postReository;

  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, CommentDisplay>> call(
    UpdateCommentParams params,
  ) async {
    return await _postsRepository.updateComment(
      commentId: params.commentId,
      newContent: params.content,
    );
  }
}
