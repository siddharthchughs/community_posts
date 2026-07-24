import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';
import '../entities/entities.dart';

abstract interface class PostsRepository {
  Future<Either<Failure, List<PostDisplayEntity>>> getPosts({
    required int offset,
    required int limit,
  });
}
