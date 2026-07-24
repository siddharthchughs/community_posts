import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
}
