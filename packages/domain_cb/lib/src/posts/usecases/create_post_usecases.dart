import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import '../posts.dart';

class CreatePostParams extends Equatable {
  final String? postId;
  final String title;
  final String content;
  final String? imageUrl;
  const CreatePostParams({
    this.postId,
    required this.title,
    required this.content,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [postId, title, content, imageUrl];
}

class CreatePostUseCase implements Usecase<PostDisplay, CreatePostParams> {
  CreatePostUseCase({required PostsRepository postReository})
    : _postsRepository = postReository;

  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, PostDisplay>> call(CreatePostParams params) async {
    return await _postsRepository.createPost(
      postId: params.postId,
      title: params.title,
      content: params.content,
      imageUrl: params.imageUrl,
    );
  }
}
