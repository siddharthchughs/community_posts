import 'dart:io';

import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import '../dto/image_upload_result.dart';
import '../posts.dart';

class UploadPostImageParams extends Equatable {
  const UploadPostImageParams({required this.image, this.postId});
  final File image;
  final String? postId;

  @override
  List<Object?> get props => [image, postId];
}

class UploadPostImageUseCase
    implements Usecase<ImageUploadResult, UploadPostImageParams> {
  UploadPostImageUseCase({required PostsRepository postRepository})
    : _postsRepository = postRepository;

  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, ImageUploadResult>> call(
    UploadPostImageParams params,
  ) async {
    return await _postsRepository.uploadPostImage(
      image: params.image,
      postId: params.postId,
    );
  }
}
