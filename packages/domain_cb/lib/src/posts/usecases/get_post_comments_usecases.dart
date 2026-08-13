import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import '../../../posts.dart';

class GetPostCommentParams extends Equatable {
  const GetPostCommentParams({
    required this.popstId,
    required this.offset,
    required this.limit,
  });
  final String popstId;
  final int offset;
  final int limit;

  @override
  List<Object> get props => [popstId, offset, limit];
}

class GetPostCommentsUsecases
    implements Usecase<List<CommentDisplay>, GetPostCommentParams> {
  GetPostCommentsUsecases({required PostsRepository postsRepository})
    : _postsRepository = postsRepository;

  final PostsRepository _postsRepository;
  @override
  Future<Either<Failure, List<CommentDisplay>>> call(
    GetPostCommentParams params,
  ) {
    return _postsRepository.getPostComments(
      postId: params.popstId,
      offset: params.offset,
      limit: params.limit,
    );
  }
}
