import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/src/either.dart';
import '../../../posts.dart';

class DeletePostUseCase implements Usecase<void, String> {
  const DeletePostUseCase({required PostsRepository postsRepository})
    : _postsRepository = postsRepository;
  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return _postsRepository.deletePost(postId: params);
  }
}
