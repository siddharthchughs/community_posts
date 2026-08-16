import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetPostCommentParams extends Equatable {
  const GetPostCommentParams({
    required this.postId,
    required this.offset,
    required this.limit,
  });
  final String postId;
  final int offset;
  final int limit;

  @override
  List<Object> get props => [postId, offset, limit];
}

class GetPostCommentsUseCase
    implements Usecase<List<CommentDisplay>, GetPostCommentParams> {
  GetPostCommentsUseCase({required PostsRepository postsRepository})
    : _postsRepository = postsRepository;

  final PostsRepository _postsRepository;
  @override
  Future<Either<Failure, List<CommentDisplay>>> call(
    GetPostCommentParams params,
  ) {
    return _postsRepository.getPostComments(
      postId: params.postId,
      offset: params.offset,
      limit: params.limit,
    );
  }
}
