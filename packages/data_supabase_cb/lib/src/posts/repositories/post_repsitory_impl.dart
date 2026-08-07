import 'dart:io';

import 'package:core/errors.dart';
import 'package:domain/posts.dart';
import 'package:fpdart/src/either.dart';

import '../posts.dart';

class PostRepsitoryImpl implements PostsRepository {
  final PostRemoteDataSource _postRemoteDataSource;
  PostRepsitoryImpl({required PostRemoteDataSource postRemoteDataSource})
    : _postRemoteDataSource = postRemoteDataSource;

  @override
  Future<Either<Failure, List<PostDisplayEntity>>> getPosts({
    required int offset,
    required int limit,
  }) async {
    try {
      final responsePost = await _postRemoteDataSource.getPosts(
        offset: offset,
        limit: limit,
      );
      print('Posts Length :: ${responsePost.length} ');
      print('Posts ${responsePost} ');
      return Right(responsePost);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PostDisplayEntity>> createPost({
    String? postId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final responsePost = await _postRemoteDataSource.createPost(
        postId: postId,
        title: title,
        content: content,
        imageUrl: imageUrl,
      );
      print('Posts ${responsePost} ');
      return Right(responsePost);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ImageUploadResult>> uploadPostImage({
    required File image,
    String? postId,
  }) async {
    try {
      final imageUpload = await _postRemoteDataSource.upLoadPostImage(
        image: image,
        postId: postId,
      );
      return Right(imageUpload);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on StorageServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }
}
