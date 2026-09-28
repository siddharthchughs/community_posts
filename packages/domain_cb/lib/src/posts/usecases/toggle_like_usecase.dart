import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../posts.dart';

class ToggleLikeUseCase implements Usecase<LikeResult, String> {
  ToggleLikeUseCase({required PostsRepository postRepository})
    : _postRepository = postRepository;

  final PostsRepository _postRepository;

  @override
  Future<Either<Failure, LikeResult>> call(String params) async {
    return await _postRepository.toggleLikePost(postId: params);
  }
}
