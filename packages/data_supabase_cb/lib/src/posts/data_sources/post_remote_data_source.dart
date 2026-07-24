import '../models/models.dart';

abstract interface class PostRemoteDataSource {
  Future<List<PostsDisplayModel>> getPosts({
    required int offset,
    required int limit,
  });
}
