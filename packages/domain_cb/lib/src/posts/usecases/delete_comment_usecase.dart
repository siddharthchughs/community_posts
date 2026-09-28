import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../posts.dart';

class DeleteCommentUseCase implements Usecase<void, String> {
  DeleteCommentUseCase({required PostsRepository postReository})
    : _postsRepository = postReository;

  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await _postsRepository.deleteComment(commentId: params);
  }
}
