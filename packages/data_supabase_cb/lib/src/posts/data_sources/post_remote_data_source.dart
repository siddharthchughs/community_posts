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
}
