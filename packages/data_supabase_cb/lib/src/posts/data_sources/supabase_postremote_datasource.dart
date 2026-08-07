import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:domain/posts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import 'post_remote_data_source.dart';

class SupabasePostremoteDatasource implements PostRemoteDataSource {
  SupabasePostremoteDatasource({required SupabaseClient client})
    : _supabaseClient = client;

  final SupabaseClient _supabaseClient;

  @override
  Future<List<PostsDisplayModel>> getPosts({
    required int offset,
    required int limit,
  }) async {
    try {
      if (_supabaseClient.auth.currentUser == null) {
        throw const AuthenticationException(
          message: 'USER IS not authorized to receive posts',
        );
      }
      final loadPageOffset = offset + limit - 1;
      final mapData = await _supabaseClient
          .from(Views.postDisplayViews)
          .select()
          .order('post_created_at', ascending: false)
          .range(offset, loadPageOffset);

      return mapData.map((p) => PostsDisplayModel.fromJson(p)).toList();
    } on AuthenticationException {
      rethrow;
    } on PostgrestException catch (e) {
      if (e.code == PostgresErrors.insufficientPrivilege) {
        throw PermissionException(message: e.message);
      }
      throw DatabaseException(message: e.message);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<PostsDisplayModel> createPost({
    String? postId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    try {
      if (_supabaseClient.auth.currentUser == null) {
        throw const AuthenticationException(
          message: 'USER IS not authorized to create posts',
        );
      }
      final post_Id = postId ?? Uuid().v4();
      final result = await _supabaseClient
          .rpc(
            DBFunctions.createPostAndReturnPostDisplayView,
            params: {
              'p_post_id': post_Id,
              'p_title': title,
              'p_content': content,
              'p_image_url': imageUrl,
            },
          )
          .single();
      return PostsDisplayModel.fromJson(result);
    } on AuthenticationException {
      rethrow;
    } on PostgrestException catch (e) {
      if (e.code == PostgresErrors.insufficientPrivilege) {
        throw PermissionException(message: e.message);
      }
      if (e.code == PostgresErrors.moreThanOneorMoreItemsreturned) {
        throw NotFoundException(message: e.message);
      }
      throw DatabaseException(message: e.message);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<PostsDisplayModel> updatePost({
    required String postId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    try {
      if (_supabaseClient.auth.currentUser == null) {
        throw const AuthenticationException(
          message: 'USER IS not authorized to update posts',
        );
      }
      final result = await _supabaseClient
          .rpc(
            DBFunctions.updatePostAndReturnPostDisplayView,
            params: {
              'p_post_id': postId,
              'p_title': title,
              'p_content': content,
              'p_image_url': imageUrl,
            },
          )
          .single();
      return PostsDisplayModel.fromJson(result);
    } on AuthenticationException {
      rethrow;
    } on PostgrestException catch (e) {
      if (e.code == PostgresErrors.insufficientPrivilege) {
        throw PermissionException(message: e.message);
      }
      throw DatabaseException(message: e.message);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<ImageUploadResult> upLoadPostImage({
    required File image,
    String? postId,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw const AuthenticationException(
          message: 'User not authenticatred for image upload',
        );
      }
      final postid = postId ?? const Uuid().v4();
      final imagePathExtension = image.path.split('.').last.toLowerCase();
      final imageFilename = '${const Uuid().v4()}.$imagePathExtension';
      final imagePath = 'public/$userId/$postid/$imageFilename';

      await _supabaseClient.storage
          .from(Storage.postImages)
          .upload(imagePath, image);

      final createImageUrl = _supabaseClient.storage
          .from(Storage.postImages)
          .getPublicUrl(imagePath);

      return ImageUploadResult(postId: postid, imageUrl: createImageUrl);
    } on AuthenticationException {
      rethrow;
    } on StorageException catch (e) {
      throw StorageServerException(message: e.message);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> deletePost({required String postId}) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }
}
