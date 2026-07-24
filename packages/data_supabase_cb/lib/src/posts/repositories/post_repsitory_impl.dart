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
      print('Posts Lenght :: ${responsePost.length} ');
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
}
