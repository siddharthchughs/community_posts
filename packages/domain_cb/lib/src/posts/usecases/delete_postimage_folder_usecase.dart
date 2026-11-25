import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/src/either.dart';

import '../../../posts.dart';

class DeletePostimageFolderUseCase implements Usecase<void, String> {
  const DeletePostimageFolderUseCase({required PostsRepository postsRepository})
    : _postsRepository = postsRepository;

  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return _postsRepository.deletePostFolder(postId: params);
  }
}
