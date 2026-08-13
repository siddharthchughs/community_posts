import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/src/either.dart';

import '../../../posts.dart';

class GetPostDetailUsecases implements Usecase<PostDisplayEntity, String> {
  GetPostDetailUsecases({required PostsRepository postsRepository})
    : _postsRepository = postsRepository;
  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, PostDisplayEntity>> call(String params) async {
    return await _postsRepository.getPostDetail(postId: params);
  }
}
