import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:domain/posts.dart';

class GetPostDetailUseCase implements Usecase<PostDisplay, String> {
  GetPostDetailUseCase({required PostsRepository postsRepository})
    : _postsRepository = postsRepository;
  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, PostDisplay>> call(String params) async {
    return await _postsRepository.getPostDetail(postId: params);
  }
}
