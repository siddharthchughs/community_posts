import 'dart:io';

import 'package:domain/posts.dart';

import '../models/models.dart';

abstract interface class PostRemoteDataSource {
  Future<List<PostsDisplayModel>> getPosts({
    required int offset,
    required int limit,
  });

  Future<PostsDisplayModel> createPost({
    String? postId,
    required String title,
    required String content,
    String? imageUrl,
  });

  Future<PostsDisplayModel> updatePost({
    required String postId,
    required String title,
    required String content,
    String? imageUrl,
  });

  Future<ImageUploadResult> upLoadPostImage({
    required File image,
    String? postId,
  });

  Future<void> deletePost({required String postId});

  Future<PostsDisplayModel> getPostDetail({required String postId});

  Future<List<PostCommentModel>> getPostComments({
    required String postId,
    required int offset,
    required int limit,
  });

  Future<LikeResultModel> toggleLikePost({required String postId});

  Future<CommentDisplay> onCreateComment({
    required String postId,
    required String content,
  });

  Future<void> deleteComment({required String commentId});

  Future<CommentDisplay> onUpdateComment({
    required String commentId,
    required String newContentUpdate,
  });
}
