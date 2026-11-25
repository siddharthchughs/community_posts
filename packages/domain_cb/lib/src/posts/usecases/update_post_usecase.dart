import 'dart:io';

import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import '../../../posts.dart';
import '../entities/entities.dart';

class UpdatePostParams extends Equatable {
  const UpdatePostParams({
    required this.originalPost,
    required this.newTitle,
    required this.newContent,
    this.fileImageUrl,
    this.isImageChanged = false,
  });
  final PostDisplay originalPost;
  final String newTitle;
  final String newContent;
  final File? fileImageUrl;
  final bool isImageChanged;

  @override
  List<Object> get props => [
    originalPost,
    newTitle,
    newContent,
    fileImageUrl ?? '',
    isImageChanged,
  ];
}

class UpdatePostUseCase implements Usecase<void, UpdatePostParams> {
  const UpdatePostUseCase({required PostsRepository postsRepository})
    : _postsRepository = postsRepository;

  final PostsRepository _postsRepository;
  @override
  Future<Either<Failure, PostDisplay>> call(UpdatePostParams params) async {
    try {
      String? newImageUrl = params.originalPost.imageUrl;
      if (params.fileImageUrl != null) {
        if (params.originalPost.imageUrl != null) {
          await _postsRepository.deletePostFolder(
            postId: params.originalPost.postId,
          );
        }
        final uploadResult = await _postsRepository.uploadPostImage(
          image: params.fileImageUrl!,
          postId: params.originalPost.postId,
        );
        newImageUrl = uploadResult
            .getOrElse((failure) => throw failure)
            .imageUrl;
      } else if (params.isImageChanged &&
          params.originalPost.imageUrl != null) {
        await _postsRepository.deletePostFolder(
          postId: params.originalPost.postId,
        );
        newImageUrl = null;
      }
      return await _postsRepository.updatePost(
        postId: params.originalPost.postId,
        title: params.newTitle,
        content: params.newContent,
        imageUrl: newImageUrl,
      );
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
