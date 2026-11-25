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
  Future<Either<Failure, List<PostDisplay>>> getPosts({
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
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PostDisplay>> createPost({
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
      print('Image Upload Result :: ${imageUpload} ');
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

  @override
  Future<Either<Failure, List<CommentDisplay>>> getPostComments({
    required String postId,
    required int offset,
    required int limit,
  }) async {
    try {
      final postComments = await _postRemoteDataSource.getPostComments(
        postId: postId,
        offset: offset,
        limit: limit,
      );
      return Right(postComments);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PostDisplay>> getPostDetail({
    required String postId,
  }) async {
    try {
      final post = await _postRemoteDataSource.getPostDetail(postId: postId);
      return Right(post);
      print('Post Detail :: ${post.likesCount.toString()}');
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LikeResult>> toggleLikePost({
    required String postId,
  }) async {
    try {
      final likedResultEmitted = await _postRemoteDataSource.toggleLikePost(
        postId: postId,
      );
      print(
        'Post Detail Result :: ${likedResultEmitted.likesCount.toString()}',
      );
      return Right(likedResultEmitted);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: ' Post Liked error: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, CommentDisplay>> createComment({
    required String postId,
    required String newContent,
  }) async {
    try {
      final newComment = await _postRemoteDataSource.onCreateComment(
        postId: postId,
        content: newContent,
      );
      return Right(newComment);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({
    required String commentId,
  }) async {
    try {
      await _postRemoteDataSource.deleteComment(commentId: commentId);
      return const Right(null);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: ' Post Liked error: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, CommentDisplay>> updateComment({
    required String commentId,
    required String newContent,
  }) async {
    try {
      final commentUpdatedResponse = await _postRemoteDataSource
          .onUpdateComment(commentId: commentId, newContentUpdate: newContent);
      return Right(commentUpdatedResponse);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost({required String postId}) async {
    try {
      await _postRemoteDataSource.deletePost(postId: postId);
      return const Right(null);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: ' Post Liked error: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePostFolder({
    required String postId,
  }) async {
    try {
      await _postRemoteDataSource.deletePostFolder(postId: postId);
      return const Right(null);
    } catch (e) {
      print('Error deleting post folder, but proceeding: $e');
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, PostDisplay>> updatePost({
    required String postId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final updatePost = await _postRemoteDataSource.updatePost(
        postId: postId,
        title: title,
        content: content,
        imageUrl: imageUrl,
      );
      print('Updated Post :: ${updatePost.likesCount.toString()}');
      return Right(updatePost);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }
}
