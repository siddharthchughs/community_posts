import 'dart:async';

import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetPostsParams extends Equatable {
  const GetPostsParams({required this.offset, required this.limit});

  final int offset;
  final int limit;

  @override
  List<Object> get props => [offset, limit];
}

class GetPostsUsecases
    implements Usecase<List<PostDisplayEntity>, GetPostsParams> {
  GetPostsUsecases({required PostsRepository postRepository})
    : _postsRepository = postRepository;

  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, List<PostDisplayEntity>>> call(
    GetPostsParams params,
  ) async {
    return await _postsRepository.getPosts(
      offset: params.offset,
      limit: params.limit,
    );
  }
}
